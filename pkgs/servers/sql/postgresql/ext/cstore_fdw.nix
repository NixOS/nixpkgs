{ stdenv, fetchFromGitHub, postgresql, protobufc }:

stdenv.mkDerivation rec {
  name = "cstore_fdw-${version}";
  version = "1.6.2";

  nativeBuildInputs = [ protobufc ];
  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "cstore_fdw";
    rev    = "refs/tags/v${version}";
    sha256 = "0kdmzpbhhjdg4p6i5963h7qbs88jzgpqc52gz450h7hwb9ckpv74";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/extension
    cp *.control $out/share/extension
  '';

  meta = with stdenv.lib; {
    description = "Columnar storage for PostgreSQL";
    homepage    = https://www.citusdata.com/;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
    license     = licenses.asl20;
  };
}
