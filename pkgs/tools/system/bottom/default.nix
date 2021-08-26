{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, DiskArbitration
, Foundation
, IOKit
, installShellFiles
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    sha256 = "sha256-hXEaQL4jTd/MfEUVKUTs7oTRAffau1YA/IUUtD+V9KI=";
  };

  prePatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    DiskArbitration
    Foundation
    IOKit
    libiconv
  ];

  cargoSha256 = "sha256-aeR6fcIWkY4AWZy8tVotUAVRVSiO/0S0DU/A9/ATrF4=";

  doCheck = false;

  postInstall = ''
    installShellCompletion $releaseDir/build/bottom-*/out/btm.{bash,fish} --zsh $releaseDir/build/bottom-*/out/_btm
  '';

  meta = with lib; {
    description = "A cross-platform graphical process/system monitor with a customizable interface";
    homepage = "https://github.com/ClementTsang/bottom";
    license = licenses.mit;
    maintainers = with maintainers; [ berbiche ];
    platforms = platforms.unix;
    mainProgram = "btm";
  };
}
