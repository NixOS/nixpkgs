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
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "rojo-rbx";
    repo = "rojo";
    rev = "v${version}";
    sha256 = "sha256-Eh1G0jX9KXVlMZLl8whxULywadblWml232qvcq4JLJ4=";
    fetchSubmodules = true;
  };

  cargoSha256 = "sha256-aKfgylY9aspL1JpdYa6hOy/6lQoqO54OhZWqSlMPZ8o=";

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
