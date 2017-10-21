source $stdenv/setup

preBuild() {
  cd src
}

preInstall() {
  mkdir -p $out/bin
}

postInstall() {
  # Install the "prefabs".
  mkdir -p $out/share/ploticus/prefabs &&		\
  cd .. &&						\
  cp -rv prefabs/* $out/share/ploticus/prefabs

  # Create a wrapper that knows where to find them.  Debian's package
  # does something similar by patching directly the C file that looks
  # for `$PLOTICUS_PREFABS'.
  cat > $out/bin/ploticus <<EOF
#! $SHELL -e
PLOTICUS_PREFABS="$out/share/ploticus/prefabs"
export PLOTICUS_PREFABS
exec "$out/bin/pl" \$@
EOF
  chmod +x $out/bin/ploticus

  # Install the man pages.
  cp -rv man $out
  ln -s "$out/man/man1/pl.1" "$out/man/man1/ploticus.1"
}

genericBuild
