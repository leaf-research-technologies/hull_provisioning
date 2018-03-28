#!/bin/bash

################################
# Create /var/run/hyrax on boot #
################################
cp /tmp/config/hyrax_run.conf /etc/tmpfiles.d/hyrax.conf