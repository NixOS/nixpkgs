source $stdenv/setup

preBuild=preBuild

preBuild() {
  sed -e "s^@bash\@^$bash^g" \
      < etc/hotplug/dasd.agent > etc/hotplug/dasd.agent.tmp
  mv etc/hotplug/dasd.agent.tmp etc/hotplug/dasd.agent

  sed -e "s^@bash\@^$bash^g" \
      < etc/hotplug/tape.agent > etc/hotplug/tape.agent.tmp
  mv etc/hotplug/tape.agent.tmp etc/hotplug/tape.agent

  sed -e "s^@bash\@^$bash^g" \
      -e "s^@gnused\@^$gnused^g" \
      -e "s^@coreutils\@^$coreutils^g" \
      < etc/hotplug.d/default/default.hotplug > etc/hotplug.d/default/default.hotplug.tmp
  mv etc/hotplug.d/default/default.hotplug.tmp etc/hotplug.d/default/default.hotplug
}

genericBuild
