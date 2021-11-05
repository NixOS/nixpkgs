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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = pname;
    rev = version;
    sha256 = "sha256-tA1exZ97N2tAagAljt+MOSGh6objOiqbZXUaBZ62Sls=";
  };

  cargoSha256 = "sha256-4vCKiTWwnibNK6/S1GOYRurgm2Aq1e9o4rAmp0hqGeA=";

  nativeBuildInputs = lib.optional robloxSupport pkg-config;

  buildInputs = lib.optional robloxSupport openssl
    ++ lib.optional (robloxSupport && stdenv.isDarwin) Security;

  cargoBuildFlags = lib.optional (!robloxSupport) "--no-default-features";

  cargoTestFlags = cargoBuildFlags;

  meta = with lib; {
    description = "A blazing-fast modern Lua linter written in Rust";
    homepage = "https://github.com/kampfkarren/selene";
    changelog = "https://github.com/kampfkarren/selene/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
