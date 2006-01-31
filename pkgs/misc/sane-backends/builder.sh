source $stdenv/setup

postInstall() {
  if test $hotplugSupport = "1" ; then
    ensureDir $out/etc/hotplug/usb/
    cp tools/hotplug/* $out/etc/hotplug/usb/
  fi
}

postInstall=postInstall

genericBuild
