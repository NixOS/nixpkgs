{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nixForLinking,
  nlohmann_json,
  boost,
  graphviz,
  Security,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-du";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    tag = "v${version}";
    hash = "sha256-RkGPXjog2XR3ISlWMQZ1rzy3SwE5IPAKP09FIZ6LwkM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-rrBFgE3Tz68gBQbz006RSdsqacSZqON78NM4FNi+wrk=";

  doCheck = true;
  nativeCheckInputs = [
    nixForLinking
    graphviz
  ];

  buildInputs = [
    boost
    nixForLinking
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
