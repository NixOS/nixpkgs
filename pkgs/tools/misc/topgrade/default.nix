{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "08vhn0w4px0j7ln1zq5zh3nplcv0xdh6z3rb8sczgjkvgi0xi4qn";
  };

  cargoSha256 = "0nwhv7j2wbzh6h4jrxsgcyvqi4sj021k74myj5y44asignacvx3i";

  meta = with stdenv.lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.filalex77 ];
  };
}
