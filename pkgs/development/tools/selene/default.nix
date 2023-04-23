{ lib
, rustPlatform
, fetchFromGitHub
, robloxSupport ? true
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "selene";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = pname;
    rev = version;
    sha256 = "sha256-aKU+1eoLm/h5Rj/vAZOyAnyl5/TpStL5g8PPdYCJ8o0=";
  };

  cargoSha256 = "sha256-y2BoV59oJPMBf9rUgMhHu87teurwPSNowRbuPfXubGA=";

  nativeBuildInputs = lib.optionals robloxSupport [
    pkg-config
  ];

  buildInputs = lib.optionals robloxSupport [
    openssl
  ] ++ lib.optionals (robloxSupport && stdenv.isDarwin) [
    darwin.apple_sdk.frameworks.Security
  ];

  buildNoDefaultFeatures = !robloxSupport;

  meta = with lib; {
    description = "A blazing-fast modern Lua linter written in Rust";
    homepage = "https://github.com/kampfkarren/selene";
    changelog = "https://github.com/kampfkarren/selene/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
