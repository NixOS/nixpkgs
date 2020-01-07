{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lj4hwinw2q9hwcxjn052y3rrpw1ri90agx3m3j0dy741hv9grmm";
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
