{ stdenv, kernel, fetchgit, perl }:

assert kernel.features ? aufsBase;

let version = "20110303"; in

stdenv.mkDerivation {
  name = "aufs2.1-${version}";

  src = fetchgit {
    url = "git://git.c3sl.ufpr.br/aufs/aufs2-standalone.git";
    rev = "aceef6c84dbe5798bf46904252727b9588eafaf6";
    sha256 = "50a8cb39af5fee82e88b65351cac52b6ab95a68c45e0a98da9fa1925b28f048d";
  };

  buildInputs = [ perl ];

  makeFlags = "KDIR=${kernel}/lib/modules/${kernel.version}/build";

  installPhase =
    ''
      ensureDir $out/lib/modules/${kernel.version}/misc
      cp -v aufs.ko $out/lib/modules/${kernel.version}/misc

      # Install the headers because aufs2.1-util requires them.
      cp -av usr/include $out/
    '';

  meta = {
    description = "Another Unionfs implementation for Linux (second generation)";
    homepage = http://aufs.sourceforge.net/;
    maintainers = [ stdenv.lib.maintainers.eelco
                    stdenv.lib.maintainers.raskin
                    stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.linux;
  };
}
