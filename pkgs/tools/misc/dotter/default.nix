{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, rustPlatform
, CoreServices
, which
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "dotter";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "SuperCuber";
    repo = "dotter";
    rev = "v${version}";
    hash = "sha256-IV3wvmRiRtzu5UhIlL1BnL8hy+fQHQA9Mfiy6dIsjdw=";
  };

  cargoHash = "sha256-jNHq1cH3I29b6LIoO2ApLDTYzFGGSua1lACvYCBpbQQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  nativeCheckInputs = [ which installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd dotter \
      --bash <($out/bin/dotter gen-completions --shell bash) \
      --fish <($out/bin/dotter gen-completions --shell fish) \
      --zsh <($out/bin/dotter gen-completions --shell zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };


  meta = with lib; {
    description = "Dotfile manager and templater written in rust 🦀";
    homepage = "https://github.com/SuperCuber/dotter";
    license = licenses.unlicense;
    maintainers = with maintainers; [ linsui ];
    mainProgram = "dotter";
  };
}
