{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DCejOfL+c04MABweyuvDLImlYKj/SONxBfXD/4OVzH0=";
  };

  cargoHash = "sha256-X+pAvudfbxng6kMv0NO00v6mMBXUMaXvZb/L1OgWd38=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "socks" ];

  meta = with lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
    mainProgram = "routinator";
  };
}
