{ stdenv, rustPlatform, fetchFromGitHub }:

with rustPlatform;

buildRustPackage rec {
  pname = "kubie";
  version = "0.7.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "186h5fng16gwqhsy2nxswbrrxsx0ysqrb4pqznyygbiz5cd9bgxp";
  };

  cargoSha256 = "1yllpi8dp1fy39z4zmhyf1hdjpl62vwh8b8qlj0g778qsdrm9p98";

  meta = with stdenv.lib; {
    description =
      "Shell independent context and namespace switcher for kubectl";
    homepage = "https://github.com/sbstp/kubie";
    license = with licenses; [ zlib ];
    maintainers = with maintainers; [ illiusdope ];
    platforms = platforms.all;
  };
}
