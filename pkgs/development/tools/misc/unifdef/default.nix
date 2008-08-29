{ fetchurl, stdenv }:

stdenv.mkDerivation {
  name = "unifdef-1.0";

  src = fetchurl {
    url = http://freshmeat.net/redir/unifdef/10933/url_tgz/unifdef-1.0.tar.gz;
    sha256 = "d14c30b1e2e9745e4b067ab86337c93ad907b4e9ee1c414d45291bf7f0c19dad";
  };

  buildPhase = ''
    make unifdef
  '';

  installPhase = ''
    ensureDir $out/bin
    cp unifdef $out/bin
  '';

  meta = {
    description = "useful for removing #ifdef'ed lines from a file while otherwise leaving the file alone";

  };
}
