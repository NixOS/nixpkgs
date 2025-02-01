{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nix,
  nlohmann_json,
  boost,
  graphviz,
  Security,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-du";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "sha256-WImnfkBU17SFQG1DzVUdsNq3hkiISNjAVZr2xGbgwHg=";
  };

  cargoHash = "sha256-gE99nCJIi6fsuxzJuU80VWXIZqVbqwBhKM2aRlhmYco=";

  doCheck = true;
  nativeCheckInputs = [
    nix
    graphviz
  ];

  buildInputs = [
    boost
    nix
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
  };
}
