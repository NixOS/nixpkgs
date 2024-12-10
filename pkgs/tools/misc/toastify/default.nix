{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "toastify";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "hoodie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hSBh1LTfe3rQDPUryo2Swdf/yLYrOQ/Fg3Dz7ZqV3gw=";
  };

  cargoHash = "sha256-Ps2pRLpPxw+OS1ungQtVQ8beoKpc8pjzQEndMNni08k=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Cocoa
  ];

  preBuild = lib.optionalString stdenv.isDarwin ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "A commandline tool that shows desktop notifications using notify-rust";
    homepage = "https://github.com/hoodie/toastify";
    changelog = "https://github.com/hoodie/toastify/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
    mainProgram = "toastify";
  };
}
