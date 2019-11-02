{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "18pgpdrkcyb1fjy8gxisc0bp688wa2jrs744hw0kj1mjmghwp6bi";
  };

  cargoSha256 = "0nwhv7j2wbzh6h4jrxsgcyvqi4sj021k74myj5y44asignacvx3i";

  meta = with stdenv.lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ filalex77 ];
  };
}
