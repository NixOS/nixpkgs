{ config, lib, stdenv, fetchurl
, yacc, flex
, sysfsutils, kmod, udev
, firmware   ? config.pcmciaUtils.firmware or [] # Special pcmcia cards.
, configOpts ? config.pcmciaUtils.config or null # Special hardware (map memory & port & irq)
}:                   # used to generate postInstall script.

# FIXME: should add an option to choose between hotplug and udev.
stdenv.mkDerivation rec {
  name = "pcmciautils-018";

  src = fetchurl {
    url = "https://kernel.org/pub/linux/utils/kernel/pcmcia/${name}.tar.gz";
    sha256 = "0sfm3w2n73kl5w7gb1m6q8gy5k4rgwvzz79n6yhs9w3sag3ix8sk";
  };

  buildInputs = [udev yacc sysfsutils kmod flex];

  patchPhase = ''
    sed -i "
      s,/sbin/modprobe,${kmod}&,;
      s,/lib/udev/,$out/sbin/,;
    " udev/* # fix-color */
    sed -i "
      s,/lib/firmware,$out&,;
      s,/etc/pcmcia,$out&,;
    " src/{startup.c,pcmcia-check-broken-cis.c} # fix-color */
  ''
  + (if firmware == [] then ''sed -i "s,STARTUP = true,STARTUP = false," Makefile'' else "")
  + (if configOpts == null then "" else ''
    ln -sf ${configOpts} ./config/config.opts'')
  ;

  makeFlags = [ "LEX=flex" ];
  installFlags = [ "INSTALL=install" "DESTDIR=${placeholder "out"}" ];
  postInstall =
    lib.concatMapStrings (path: ''
      for f in : $(find ${path} -type f); do
        test "$f" == ":" && continue;
        mkdir -p $(dirname $out/lib/firmware/$\{f#${path}});
        ln -s $f $out/lib/firmware/$\{f#${path}};
      done;
    '') firmware;

  meta = {
    homepage = https://www.kernel.org/pub/linux/utils/kernel/pcmcia/;
    longDescription = "
      PCMCIAutils contains the initialization tools necessary to allow
      the PCMCIA subsystem to behave (almost) as every other
      hotpluggable bus system.
    ";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
