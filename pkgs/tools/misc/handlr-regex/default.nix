{ lib, rustPlatform, fetchFromGitHub, shared-mime-info, libiconv, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "handlr-regex";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "Anomalocaridid";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-X0j62Ntu/ouBVm09iKxU3pps8mbL5V5gA65Maa4b0AY=";
  };

  cargoSha256 = "sha256-byR7CM876z5tAXmbcUfI0CnJrc/D6CxfjBJhuJMSFmg=";

  nativeBuildInputs = [ installShellFiles shared-mime-info ];
  buildInputs = [ libiconv ];

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  postInstall = ''
    installShellCompletion \
      --zsh assets/completions/_handlr \
      --bash assets/completions/handlr \
      --fish assets/completions/handlr.fish

    installManPage assets/manual/man1/*
  '';

  meta = with lib; {
    description = "Fork of handlr with support for regex";
    homepage = "https://github.com/Anomalocaridid/handlr-regex";
    license = licenses.mit;
    maintainers = with maintainers; [ anomalocaris ];
  };
}
