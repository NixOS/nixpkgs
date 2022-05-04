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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = pname;
    rev = version;
    sha256 = "sha256-S0EeFJS90bzQ7C+hN4CyZ7l9wmizT2d3P6utshI5JWs=";
  };

  cargoSha256 = "sha256-3J1Q595LxAI0LBP4/cLHDrMbZBnoA2+OSr8/erQcN+0=";

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
