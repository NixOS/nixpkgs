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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    sha256 = "sha256-QCi6Oi5xk88ev2B4rlXwgR55qKZSUbIY/96t/jhJQ0Q=";
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

  cargoSha256 = "sha256-RJ7xIp9EBiBLSMAchr7XYhrTITNJy+Yfok//vZr3Z38=";

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
