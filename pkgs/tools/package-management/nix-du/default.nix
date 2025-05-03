{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nixVersions,
  nlohmann_json,
  boost,
  graphviz,
  Security,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-du";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    tag = "v${version}";
    hash = "sha256-/Afp0InA/0xXdombAzylYJF9wcv5WwYizVsP+fHTDrM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Q/woxGh1I6FpgJ5D0x7KovSwuRXfZzqjzwljaoKj0/Y=";

  doCheck = true;
  nativeCheckInputs = [
    nixVersions.nix_2_24
    graphviz
  ];

  buildInputs = [
    boost
    nixVersions.nix_2_24
    nlohmann_json
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  meta = with lib; {
    description = "Tool to determine which gc-roots take space in your nix store";
    homepage = "https://github.com/symphorien/nix-du";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.unix;
    mainProgram = "nix-du";
    changelog = "https://github.com/symphorien/nix-du/blob/v${version}/CHANGELOG.md";
  };
}
