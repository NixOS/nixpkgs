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
  version = "7.2.1";

  src = fetchFromGitHub {
    owner = "rojo-rbx";
    repo = "rojo";
    rev = "v${version}";
    sha256 = "sha256-Kmq/lBwayYkFU4mbjExj7M9wpg59OkIiTc+2ZrwpuBc=";
    fetchSubmodules = true;
  };

  cargoSha256 = "sha256-qx6Ja0DMe4cEmDSpovtY9T3+0nJS9XivR92K3UKgacE=";

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
