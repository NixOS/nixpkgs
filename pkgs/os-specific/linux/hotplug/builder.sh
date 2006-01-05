source $stdenv/setup

preBuild=preBuild

preBuild() {
  sed -e "s^@bash\@^$bash^g" \
      < etc/hotplug/dasd.agent > etc/hotplug/dasd.agent.tmp
  mv etc/hotplug/dasd.agent.tmp etc/hotplug/dasd.agent

  sed -e "s^@bash\@^$bash^g" \
      < etc/hotplug/tape.agent > etc/hotplug/tape.agent.tmp
  mv etc/hotplug/tape.agent.tmp etc/hotplug/tape.agent

  sed -e "s^@coreutils\@^$coreutils^g" \
      < etc/hotplug/hotplug.functions > etc/hotplug/hotplug.functions.tmp
  mv etc/hotplug/hotplug.functions.tmp etc/hotplug/hotplug.functions

  sed -e "s^@coreutils\@^$coreutils^g" \
      < etc/hotplug/input.rc > etc/hotplug/input.rc.tmp
  mv etc/hotplug/input.rc.tmp etc/hotplug/input.rc

  sed -e "s^@coreutils\@^$coreutils^g" \
      < etc/hotplug/pci.rc > etc/hotplug/pci.rc.tmp
  mv etc/hotplug/pci.rc.tmp etc/hotplug/pci.rc

  sed -e "s^@coreutils\@^$coreutils^g" \
      -e "s^@gnugrep\@^$gnugrep^g" \
      -e "s^@utillinux\@^$utillinux^g" \
      -e "s^@module_init_tools\@^$module_init_tools^g" \
      -e "s^@gnused\@^$gnused^g" \
      -e "s^@procps\@^$procps^g" \
      < etc/hotplug/usb.rc > etc/hotplug/usb.rc.tmp
  mv etc/hotplug/usb.rc.tmp etc/hotplug/usb.rc

  sed -e "s^@bash\@^$bash^g" \
      -e "s^@gnused\@^$gnused^g" \
      -e "s^@coreutils\@^$coreutils^g" \
      < etc/hotplug.d/default/default.hotplug > etc/hotplug.d/default/default.hotplug.tmp
  mv etc/hotplug.d/default/default.hotplug.tmp etc/hotplug.d/default/default.hotplug
}

genericBuild
