{ stdenv, fetchurl, php, which, gnused, makeWrapper, gnumake, gcc }:

stdenv.mkDerivation rec {
  pname = "phoronix-test-suite";
  version = "9.0.0";

  src = fetchurl {
    url = "https://phoronix-test-suite.com/releases/${pname}-${version}.tar.gz";
    sha256 = "1gfmkwfzgpbmhv2wdr5aiknv1jyazx7sb33nna34pnd3bkmak0bq";
  };

  buildInputs = [ php ];
  nativeBuildInputs = [ which gnused makeWrapper ];

  installPhase = ''
    ./install-sh $out
    wrapProgram $out/bin/phoronix-test-suite \
    --set PHP_BIN ${php}/bin/php \
    --prefix PATH : ${stdenv.lib.makeBinPath [ gnumake gcc ]}
  '';

  meta = with stdenv.lib; {
    description = "Open-Source, Automated Benchmarking";
    homepage = https://www.phoronix-test-suite.com/;
    maintainers = with maintainers; [ davidak ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
  };
}
