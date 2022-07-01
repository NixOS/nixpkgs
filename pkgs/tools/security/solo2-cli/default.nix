{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, pcsclite
, udev
, PCSC
, IOKit
, CoreFoundation
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "solo2-cli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CRufj4SAkM0Qdffq45dp41TUqnnWep4zCB0XrEjdoG8=";
  };

  cargoSha256 = "sha256-Q6/Vi5TB0H3OQ4np/DYIpTOsTPTSDjHonFI24LJ5gWE=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ ]
    ++ lib.optionals stdenv.isLinux [ pcsclite udev ]
    ++ lib.optionals stdenv.isDarwin [ PCSC IOKit CoreFoundation AppKit ];

  postInstall = ''
    install -D 70-solo2.rules $out/lib/udev/rules.d/70-solo2.rules
    installShellCompletion target/*/release/solo2.{bash,fish,zsh}
  '';

  doCheck = true;

  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "A CLI tool for managing SoloKeys' Solo2 USB security keys.";
    homepage = "https://github.com/solokeys/solo2-cli";
    license = with licenses; [ asl20 mit ]; # either at your option
    maintainers = with maintainers; [ lukegb ];
    mainProgram = "solo2";
  };
}
