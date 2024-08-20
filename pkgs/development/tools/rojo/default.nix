{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, darwin
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices SystemConfiguration;
in
rustPlatform.buildRustPackage rec {
  pname = "rojo";
  version = "7.4.3";

  src = fetchFromGitHub {
    owner = "rojo-rbx";
    repo = "rojo";
    rev = "v${version}";
    hash = "sha256-oCG0dD1nVk5bpz3QID4kKjzGN6JH6iZXir/PzIrayaU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-c+uPLZU9uGbaNjs5b6Us393QSJKdUub27ZqggQqgriU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
    SystemConfiguration
  ];

  # reqwest's native-tls-vendored feature flag uses vendored openssl. this disables that
  OPENSSL_NO_VENDOR = "1";

  # tests flaky on darwin on hydra
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Project management tool for Roblox";
    mainProgram = "rojo";
    longDescription = ''
      Rojo is a tool designed to enable Roblox developers to use professional-grade software engineering tools.
    '';
    homepage = "https://rojo.space";
    downloadPage = "https://github.com/rojo-rbx/rojo/releases/tag/v${version}";
    changelog = "https://github.com/rojo-rbx/rojo/raw/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ wackbyte ];
  };
}
