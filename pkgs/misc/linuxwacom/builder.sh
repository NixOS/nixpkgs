source $stdenv/setup

postInstall() {
  if test -n "$udevSupport"; then
    ensureDir $out/etc/udev/rules.d
    cp $udevRules $out/etc/udev/rules.d/10-wacom.rules
  fi
}

postInstall=postInstall

genericBuild
