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
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = pname;
    rev = version;
    sha256 = "sha256-0imHwZNyhJXFai1J5tHqnQ6Ta10nETQ5TILGH0bHc8Y=";
  };

  cargoHash = "sha256-Lm3agCnxDxcj7op17uiokK8Y790oMxwHJStvP/9DsI0=";

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
