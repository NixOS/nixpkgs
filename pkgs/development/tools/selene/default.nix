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
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = pname;
    rev = version;
    sha256 = "sha256-a3mslAqDzUlMLBMjxScMkR4GePmpBeH+Ottd1ENum/c=";
  };

  cargoSha256 = "sha256-nFtZDoNbUxO5YY+Mqu5W6AR+tH2zsBLMQ7EDK6A8qAg=";

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
