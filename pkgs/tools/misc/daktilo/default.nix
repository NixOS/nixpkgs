{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
, unixtools
, pkg-config
, alsa-lib
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "daktilo";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "daktilo";
    rev = "v${version}";
    hash = "sha256-kbJwBOUODtHdngbfa6HbbQJ0kgW6f64c0EG3y8wLymw=";
  };

  cargoHash = "sha256-u9vL2HAUgP43ZDwIEK2u/I+KUEjQsfXda03gnGJ1Krc=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    xorg.libX11
    xorg.libXi
    xorg.libXtst
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
    unixtools.script
  ];

  postInstall = ''
    mkdir -p man completions

    OUT_DIR=man $out/bin/daktilo-mangen
    OUT_DIR=completions $out/bin/daktilo-completions

    installManPage man/daktilo.1
    installShellCompletion \
      completions/daktilo.{bash,fish} \
      --zsh completions/_daktilo

    rm $out/bin/daktilo-{completions,mangen}
  '';

  meta = with lib; {
    description = "Turn your keyboard into a typewriter";
    homepage = "https://github.com/orhun/daktilo";
    changelog = "https://github.com/orhun/daktilo/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ orhun ];
    mainProgram = "daktilo";
  };
}
