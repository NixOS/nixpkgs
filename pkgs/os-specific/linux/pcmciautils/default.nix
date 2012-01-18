{ stdenv, fetchurl
, yacc, flex
, sysfsutils, module_init_tools, udev
, firmware # Special pcmcia cards.
, config   # Special hardware (map memory & port & irq)
, lib      # used to generate postInstall script.
}:

# FIXME: should add an option to choose between hotplug and udev.
stdenv.mkDerivation rec {
  name = "pcmciautils-015";

  src = fetchurl {
    url = "http://kernel.org/pub/linux/utils/kernel/pcmcia/${name}.tar.bz2";
    sha256 = "4847485c412b47e3d88fa83ef811229e0e7941217303bc8449c30a3dc2128b6e";
  };

  buildInputs = [udev yacc sysfsutils module_init_tools flex];

  patchPhase = ''
    sed -i "
      s,/sbin/modprobe,${module_init_tools}&,;
      s,/lib/udev/,$out/sbin/,;
    " udev/* # fix-color */
    sed -i "
      s,/lib/firmware,$out&,;
      s,/etc/pcmcia,$out&,;
    " src/{startup.c,pcmcia-check-broken-cis.c} # fix-color */
  ''
  + (if firmware == [] then ''sed -i "s,STARTUP = true,STARTUP = false," Makefile'' else "")
  + (if config == null then "" else ''
    ln -sf ${config} ./config/config.opts'')
  ;

  makeFlags = "LEX=flex";
  installFlags = ''INSTALL=install DESTDIR=''${out}'';
  postInstall =
    lib.concatMapStrings (path: ''
      for f in : $(find ${path} -type f); do
        test "$f" == ":" && continue;
        mkdir -p $(dirname $out/lib/firmware/$\{f#${path}});
        ln -s $f $out/lib/firmware/$\{f#${path}};
      done;
    '') firmware;

  meta = {
    homepage = http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html;
    longDescription = "
      PCMCIAutils contains the initialization tools necessary to allow
      the PCMCIA subsystem to behave (almost) as every other
      hotpluggable bus system.
    ";
    license = "GPL2";
  };
}
