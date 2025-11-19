#!/bin/bash

fakeroot bash <<'EOF'
    chown -R 1000:1000 rootfs/app
    chown -R 0:0 rootfs/system
    tar --numeric-owner -czf patches.tar.gz -C rootfs app system
EOF
