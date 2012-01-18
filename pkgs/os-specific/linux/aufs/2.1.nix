{ stdenv, kernel, fetchgit, perl }:

assert kernel.features ? aufsBase;

let version = 
  if (builtins.lessThan (builtins.compareVersions kernel.version "2.6.38") 0) 
  then "20110303"
  else "20110408"; in

stdenv.mkDerivation {
  name = "aufs2.1-${version}-${kernel.version}";

  src =
  if (builtins.lessThan (builtins.compareVersions kernel.version "2.6.38") 0) 
  then
    fetchgit {
      url = "git://git.c3sl.ufpr.br/aufs/aufs2-standalone.git";
      rev = "aceef6c84dbe5798bf46904252727b9588eafaf6";
      sha256 = "50a8cb39af5fee82e88b65351cac52b6ab95a68c45e0a98da9fa1925b28f048d";
    }
  else
    fetchgit {
      url = "git://git.c3sl.ufpr.br/aufs/aufs2-standalone.git";
      rev = "01cb6101f477339bc95e6b47e3618bb29ecc68db";
      sha256 = "4af3c4b1e99ef58abe8530665309021d541ee840ee54f442606cc418646a1faf";
    };

  buildInputs = [ perl ];

  makeFlags = "KDIR=${kernel}/lib/modules/${kernel.version}/build";

  installPhase =
    ''
      mkdir -p $out/lib/modules/${kernel.version}/misc
      cp -v aufs.ko $out/lib/modules/${kernel.version}/misc

      # Install the headers because aufs2.1-util requires them.
      cp -av usr/include $out/
    '';

  meta = {
    description = "Another Unionfs implementation for Linux (second generation)";
    homepage = http://aufs.sourceforge.net/;
    maintainers = [ stdenv.lib.maintainers.eelco
                    stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
