{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vs0gnfs9swlmzsj7m3b88xfzcfy7n68bgm4i94csc3qsbip6m0j";
  };

  cargoSha256 = "1y85hl7xl60vsj3ivm6pyd6bvk39wqg25bqxfx00r9myha94iqmd";

  meta = with stdenv.lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ filalex77 ];
  };
}
