{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, darwin
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices;
in
rustPlatform.buildRustPackage rec {
  pname = "rojo";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "rojo-rbx";
    repo = "rojo";
    rev = "v${version}";
    hash = "sha256-Lc69wuvcBOKAVcfDR1rbr8WeG0+/xPKM5hhpn4CSl5Q=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-7G/tXs26/bdchdvh4WLyP/Klu/Ol/lZKupfMj9VzxYc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
  ];

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
