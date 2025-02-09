{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  pcsclite,
  udev,
  PCSC,
  IOKit,
  CoreFoundation,
  AppKit,
}:

rustPlatform.buildRustPackage rec {
  pname = "solo2-cli";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7tpO5ir42mIKJXD0NJzEPXi/Xe6LdyEeBQWNfOdgX5I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qD185H6wfW9yuYImTm9hqSgQpUQcKuCESM8riZwmGY0=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [ ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pcsclite
      udev
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      PCSC
      IOKit
      CoreFoundation
      AppKit
    ];

  postInstall = ''
    install -D 70-solo2.rules $out/lib/udev/rules.d/70-solo2.rules
    installShellCompletion target/*/release/solo2.{bash,fish}
    installShellCompletion --zsh target/*/release/_solo2
  '';

  doCheck = true;

  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "CLI tool for managing SoloKeys' Solo2 USB security keys";
    homepage = "https://github.com/solokeys/solo2-cli";
    license = with licenses; [
      asl20
      mit
    ]; # either at your option
    maintainers = with maintainers; [ lukegb ];
    mainProgram = "solo2";
  };
}
