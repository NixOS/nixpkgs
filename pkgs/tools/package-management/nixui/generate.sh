#!/bin/sh -e

node2nix -i pkg.json -c nixui.nix -e ../../../development/node-packages/node-env.nix
