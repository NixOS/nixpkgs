{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "module-init-tools-3.4";
  
  src = [
    (fetchurl {
      url = mirror://kernel/linux/utils/kernel/module-init-tools/module-init-tools-3.4.tar.bz2;
      sha256 = "11rxcdr915skc1m6dcavavw8dhcsy24wpi56sw1m4akj2frs3iwn";
    })

    # Upstream forgot to include the generated manpages.  Thankfully
    # the Gentoo people fixed this for us :-)
    (fetchurl {
      url = mirror://gentoo/distfiles/module-init-tools-3.4-manpages.tar.bz2;
      sha256 = "0jid24girjhr30mrdckylkcz11v4in46nshhrqv18yaxm6506v6j";
    })
  ];

  patches = [./module-dir.patch];
  
  postInstall = "rm $out/sbin/insmod.static"; # don't need it

  # We don't want bash (and therefore glibc) in the closure of the
  # output, since we want to put this in a initrd.
  dontPatchShebangs = stdenv ? isDietLibC;

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/kernel/module-init-tools/;
    description = "Tools for loading and managing Linux kernel modules";
  };
}
