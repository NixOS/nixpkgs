#!/usr/bin/env bash
rm gemset.nix Gemfile.lock
nix-shell ../../../.. -A asciidoctor.updateShell --run '
  bundix -m --bundle-pack-path $TMPDIR/asciidoctor-ruby-bundle
'
rm -r .bundle
