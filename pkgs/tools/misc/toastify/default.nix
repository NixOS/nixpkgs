{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "toastify";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "hoodie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fCwxFdpwtG83xw3DDt9rlnbY8V3eKemRFK/6E1Bhm4c=";
  };

  cargoHash = "sha256-ecc3z0T82pYR9gSYZYxRYhse9IroydPOAtRgDWqHTbo=";

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
  };
}
