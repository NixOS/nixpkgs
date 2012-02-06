{ fetchurl, stdenv }:

let
  rev = "269cc6";

  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/gitweb/?p=hardlink.git;a=blob_plain;f=hardlink.c;hb=${rev}";
    sha256 = "721c54e653772e11bf0d30fb02aa21b96b147a1b68c0acb4f05cb87e7718bc12";
    name = "hardlink.c";
  };

  man =  fetchurl {
    url = "pkgs.fedoraproject.org/gitweb/?p=hardlink.git;a=blob_plain;f=hardlink.1;hb=${rev}";
    sha256 = "2f7e18a0259a2ceae316592e8b18bee525eb7e83fe3bb6b881e5dafa24747f2d";
    name = "hardlink.1";
  };
in
stdenv.mkDerivation {
  name = "hardlink-2010.1.${rev}";

  phases = ["buildPhase"];

  buildPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    gcc -O2 ${src} -o $out/bin/hardlink
    install -m 444 ${man} $out/share/man/man1/hardlink.1
  '';

  meta = {
    homepage = "http://pkgs.fedoraproject.org/gitweb/?p=hardlink.git;a=summary";
    description = "consolidate duplicate files via hardlinks";
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
