#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnused

sed -i "s| a/node_modules| a/deps/npm/node_modules|" node-npm-build-npm-package-logic.patch
sed -i "s| b/node_modules| b/deps/npm/node_modules|" node-npm-build-npm-package-logic.patch
sed -i "s| a/workspaces| a/deps/npm/node_modules/@npmcli|" node-npm-build-npm-package-logic.patch
sed -i "s| b/workspaces| b/deps/npm/node_modules/@npmcli|" node-npm-build-npm-package-logic.patch
