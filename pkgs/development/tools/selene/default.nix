{ lib
, rustPlatform
, fetchFromGitHub
, robloxSupport ? true
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "selene";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = pname;
    rev = version;
    sha256 = "sha256-ScO2ih+Y8R1OrazSmLlz9QtTUjQ6tIPf5F5juj2nc7Y=";
  };

  cargoSha256 = "sha256-pJZrNjgtYjribIKo4DWR47dnyoSuy9sSRPd+ginDlOU=";

  nativeBuildInputs = lib.optional robloxSupport pkg-config;

  buildInputs = lib.optional robloxSupport openssl
    ++ lib.optional (robloxSupport && stdenv.isDarwin) Security;

  buildNoDefaultFeatures = !robloxSupport;

  meta = with lib; {
    description = "A blazing-fast modern Lua linter written in Rust";
    homepage = "https://github.com/kampfkarren/selene";
    changelog = "https://github.com/kampfkarren/selene/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
