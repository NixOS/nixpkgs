{stdenv, fetchurl}:

let
  version = "5.1.7";
in
stdenv.mkDerivation {
  name = "unrar-${version}";

  src = fetchurl {
    url = "http://www.rarlab.com/rar/unrarsrc-${version}.tar.gz";
    sha256 = "13ida8vcamiagl40d9yfjma9k6givxczhx278f1p7bv9wgb8gfmc";
  };

  installPhase = ''
    installBin unrar

    mkdir -p $out/share/doc/unrar
    cp acknow.txt license.txt \
        $out/share/doc/unrar
  '';

  meta = with stdenv.lib; {
    description = "Utility for RAR archives";
    homepage = http://www.rarlab.com/;
    license = licenses.unfreeRedistributable;
    maintainers = [ maintainers.emery ];
    platforms = platforms.all;
  };
}
