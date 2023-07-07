{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QH4M6Kr6UiDJAaDtEn2GXQT9oSSz3lqkf+VE0GfOqeg=";
  };

  cargoSha256 = "sha256-lzw26aat+Zk0E70H7/xwZ6azRMkknfQmTrE4wOJRwfo=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "socks" ];

  meta = with lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
