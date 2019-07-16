#!/usr/bin/env bash
nix-shell ../../../.. -A asciidoctor.updateShell --run '
  rm gemset.nix Gemfile.lock
  bundix -m --bundle-pack-path $TMPDIR/asciidoctor-ruby-bundle
  rm -r .bundle
'
