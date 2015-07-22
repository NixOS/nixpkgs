{ stdenv, fetchurl, fetchgit, autogen, flex, bison, python, autoconf, automake
, gettext, ncurses, libusb, freetype, qemu, devicemapper
}:

with stdenv.lib;
let
  pcSystems = {
    "i686-linux".target = "i386";
    "x86_64-linux".target = "i386";
  };

  inPCSystems = any (system: stdenv.system == system) (mapAttrsToList (name: _: name) pcSystems);

  version = "2.0-git-2015-07-04";

  unifont_bdf = fetchurl {
    url = "http://unifoundry.com/unifont-5.1.20080820.bdf.gz";
    sha256 = "0s0qfff6n6282q28nwwblp5x295zd6n71kl43xj40vgvdqxv0fxx";
  };

  po_src = fetchurl {
    name = "grub-2.02-beta2.tar.gz";
    url = "http://alpha.gnu.org/gnu/grub/grub-2.02~beta2.tar.gz";
    sha256 = "1lr9h3xcx0wwrnkxdnkfjwy08j7g7mdlmmbdip2db4zfgi69h0rm";

  };

in (

stdenv.mkDerivation rec {
  name = "trustedGRUB-${version}";

  src = fetchgit {
    url = "https://github.com/Sirrix-AG/TrustedGRUB2";
    rev = "1865d07bdef7f39916790c77103fb85e99de14a4";
    sha256 = "e6bd9edfeb653e98e585fd691a31533b649b2fca1f4a903c70f6ea371014c9f7";
  };

  nativeBuildInputs = [ autogen flex bison python autoconf automake ];
  buildInputs = [ ncurses libusb freetype gettext devicemapper ]
    ++ optional doCheck qemu;

  preConfigure =
    '' for i in "tests/util/"*.in
       do
         sed -i "$i" -e's|/bin/bash|/bin/sh|g'
       done

       # Apparently, the QEMU executable is no longer called
       # `qemu-system-i386', even on i386.
       #
       # In addition, use `-nodefaults' to avoid errors like:
       #
       #  chardev: opening backend "stdio" failed
       #  qemu: could not open serial device 'stdio': Invalid argument
       #
       # See <http://www.mail-archive.com/qemu-devel@nongnu.org/msg22775.html>.
       sed -i "tests/util/grub-shell.in" \
           -e's/qemu-system-i386/qemu-system-x86_64 -nodefaults/g'
    '';

  prePatch =
    '' tar zxf ${po_src} grub-2.02~beta2/po
       rm -rf po
       mv grub-2.02~beta2/po po
       sh autogen.sh
       gunzip < "${unifont_bdf}" > "unifont.bdf"
       sed -i "configure" \
           -e "s|/usr/src/unifont.bdf|$PWD/unifont.bdf|g"
    '';

  patches = [ ./fix-bash-completion.patch ];

  # save target that grub is compiled for
  grubTarget = if inPCSystems
               then "${pcSystems.${stdenv.system}.target}-pc"
               else "";

  doCheck = false;
  enableParallelBuilding = true;

  postInstall = ''
    paxmark pms $out/sbin/grub-{probe,bios-setup}
  '';

  meta = with stdenv.lib; {
    description = "GRUB 2.0 extended with TCG (TPM) support for integrity measured boot process (trusted boot)";
    homepage = https://github.com/Sirrix-AG/TrustedGRUB2;
    license = licenses.gpl3Plus;
    platforms = platforms.gnu;
  };
})
