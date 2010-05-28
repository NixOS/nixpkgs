{ stdenv, fetchurl, kernel, perl }:

let version = "20100522"; in

stdenv.mkDerivation {
  name = "aufs2-${version}";

  src = fetchurl {
    url = "http://nixos.org/tarballs/aufs2-standalone-git-${version}.tar.bz2";
    sha256 = "1g4mw4qx2xzpygdwjiw36bkhfz1hi7wxx7w79n2h0lr5grzzdnd6";
  };

  buildInputs = [ perl ];

  makeFlags = "KDIR=${kernel}/lib/modules/${kernel.version}/build";

  installPhase =
    ''
      ensureDir $out/lib/modules/${kernel.version}/misc
      cp aufs.ko $out/lib/modules/${kernel.version}/misc

      # Install the headers because aufs2-util requires them.
      cp -prvd include $out/
    '';

  meta = {
    description = "Another Unionfs implementation for Linux (second generation)";
    homepage = http://aufs.sourceforge.net/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
