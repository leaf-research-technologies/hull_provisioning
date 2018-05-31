#!/bin/bash

################################
# Create /var/run/hullsync on boot #
################################
cp /tmp/config/hullsync_run.conf /etc/tmpfiles.d/hullsync.conf