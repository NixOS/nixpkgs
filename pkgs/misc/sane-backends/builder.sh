source $stdenv/setup

postInstall() {
  if test "$udevSupport" = "1" ; then
    ensureDir $out/etc/udev/rules.d/
    cp tools/udev/libsane.rules $out/etc/udev/rules.d/60-libsane.rules
  fi
}

postInstall=postInstall

genericBuild
