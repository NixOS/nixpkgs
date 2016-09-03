{ stdenv, fetchurl, kernel, perl, kmod }:

stdenv.mkDerivation {
  name = "ndiswrapper-1.59-${kernel.version}";

  hardeningDisable = [ "pic" ];

  patches = [ ./no-sbin.patch ];

  # need at least .config and include 
  kernel = kernel.dev;

  buildPhase = "
    echo make KBUILD=$(echo \$kernel/lib/modules/*/build);
    echo -n $kernel/lib/modules/*/build > kbuild_path
    export PATH=${kmod}/sbin:$PATH
    make KBUILD=$(echo \$kernel/lib/modules/*/build);
  ";

  installPhase = ''
    make install KBUILD=$(cat kbuild_path) DESTDIR=$out
    mv $out/usr/sbin/* $out/sbin/
    mv $out/usr/share $out/
    rm -r $out/usr

    patchShebangs $out/sbin
  '';

  # should we use unstable? 
  src = fetchurl {
    url = mirror://sourceforge/ndiswrapper/ndiswrapper-1.59.tar.gz;
    sha256 = "1g6lynccyg4m7gd7vhy44pypsn8ifmibq6rqgvc672pwngzx79b6";
  };

  buildInputs = [ perl ];

  meta = { 
    description = "Ndis driver wrapper for the Linux kernel";
    homepage = http://sourceforge.net/projects/ndiswrapper;
    license = "GPL";
  };
}
