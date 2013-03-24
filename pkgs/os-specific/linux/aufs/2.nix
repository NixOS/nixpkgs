{ stdenv, fetchurl, kernelDev, perl, fetchgit }:

assert kernelDev.features ? aufsBase;

let version = "20100522"; in

stdenv.mkDerivation {
  name = "aufs2-${version}-${kernelDev.version}";

  src = 
  if (builtins.lessThan (builtins.compareVersions kernelDev.version "2.6.35") 0) then
    fetchurl {
      url = "http://nixos.org/tarballs/aufs2-standalone-git-${version}.tar.bz2";
      sha256 = "1g4mw4qx2xzpygdwjiw36bkhfz1hi7wxx7w79n2h0lr5grzzdnd6";
    }
  else
    fetchgit {
      url = "http://git.c3sl.ufpr.br/pub/scm/aufs/aufs2-standalone.git";
      rev = "d950eef373ff1e0448ad3945b734da6ab050571d";
      sha256 = "816145b0341bd7862df50c058144cf6ebc25c05d2976f781ff0fe10d4559b853";
    };

  buildInputs = [ perl ];

  makeFlags = "KDIR=${kernelDev}/lib/modules/${kernelDev.version}/build";

  installPhase =
    ''
      mkdir -p $out/lib/modules/${kernelDev.version}/misc
      cp aufs.ko $out/lib/modules/${kernelDev.version}/misc

      # Install the headers because aufs2-util requires them.
      cp -prvd include $out/
    '';

  meta = {
    description = "Another Unionfs implementation for Linux (second generation)";
    homepage = http://aufs.sourceforge.net/;
    maintainers = [ stdenv.lib.maintainers.eelco
                    stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
