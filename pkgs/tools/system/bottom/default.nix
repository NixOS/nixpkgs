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
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    sha256 = "sha256-4L8TUfpEfhjfE1E8GjpRnXPf8kfXdJ02FEusXB/dZWo=";
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

  cargoSha256 = "sha256-pfDj3lbJpoqnUnzGL64Azcj2HU/UhRe1k55Unh85C/k=";

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
