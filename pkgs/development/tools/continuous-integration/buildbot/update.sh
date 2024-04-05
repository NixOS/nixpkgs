#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update
set -eu -o pipefail

nix-update buildbot
nix-update --version=skip buildbot-worker
nix-update --version=skip buildbot-plugins.buildbot-pkg
nix-update --version=skip buildbot-plugins.www
nix-update --version=skip buildbot-plugins.www-react
nix-update --version=skip buildbot-plugins.console-view
nix-update --version=skip buildbot-plugins.react-console-view
nix-update --version=skip buildbot-plugins.waterfall-view
nix-update --version=skip buildbot-plugins.react-waterfall-view
nix-update --version=skip buildbot-plugins.grid-view
nix-update --version=skip buildbot-plugins.react-grid-view
nix-update --version=skip buildbot-plugins.wsgi-dashboards
nix-update --version=skip buildbot-plugins.react-wsgi-dashboards
nix-update --version=skip buildbot-plugins.badges
