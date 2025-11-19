#!/system/bin/ash

ACTION="$1"

DROPBEAR_PIDFILE="/var/run/dropbear.pid"

is_dropbear_up() {
    if [ -f "$DROPBEAR_PIDFILE" ]; then
        pid="$(cat "$DROPBEAR_PIDFILE" 2>/dev/null)"
        if [ -n "$pid" ] && [ -d "/proc/$pid" ]; then
            return 0
        fi
    fi
    ps | grep '[d]ropbear' >/dev/null 2>&1 && return 0
    return 1
}

is_telnetd_up() {
    pgrep -f telnetd >/dev/null 2>&1 && return 0
    return 1
}

start_dropbear() {
    dropbear -R -D /root/.ssh/ &
    sleep 1
}

stop_dropbear() {
    pkill -f dropbear
}

start_telnetd() {
    /system/bin/telnetd -l /system/bin/ash -p 2323 &
    sleep 1
}

stop_telnetd() {
    pkill -f telnetd
}

case "$ACTION" in
    "")
        echo "text:Dropbear"
        if is_dropbear_up; then
            echo "item:<Enable>:DROPBEAR_ENABLE"
            echo "item:Disable:DROPBEAR_DISABLE"
        else
            echo "item:Enable:DROPBEAR_ENABLE"
            echo "item:<Disable>:DROPBEAR_DISABLE"
        fi

        echo "text:Telnetd"
        if is_telnetd_up; then
            echo "item:<Enable>:TELNET_ENABLE"
            echo "item:Disable:TELNET_DISABLE"
        else
            echo "item:Enable:TELNET_ENABLE"
            echo "item:<Disable>:TELNET_DISABLE"
        fi
    ;;
    DROPBEAR_ENABLE)
        start_dropbear
        if is_dropbear_up; then
            echo "text:Dropbear started"
        else
            echo "text:Failed to start Dropbear"
        fi
    ;;
    DROPBEAR_DISABLE)
        stop_dropbear
        if is_dropbear_up; then
            echo "text:Failed to stop Dropbear"
        else
            echo "text:Dropbear stopped"
        fi
    ;;
    TELNET_ENABLE)
        start_telnetd
        if is_telnetd_up; then
            echo "text:Telnetd started"
        else
            echo "text:Failed to start Telnetd"
        fi
    ;;
    TELNET_DISABLE)
        stop_telnetd
        if is_telnetd_up; then
            echo "text:Failed to stop Telnetd"
        else
            echo "text:Telnetd stopped"
        fi
    ;;
esac
