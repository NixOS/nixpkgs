{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, withFzf ? true
, fzf
, installShellFiles
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "zoxide";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "refs/tags/v${version}";
    hash = "sha256-Yp7uLoFEDkb0TztcDCeAkt+EHQRt56ncPqkBtd/zzzI=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  postPatch = lib.optionalString withFzf ''
    substituteInPlace src/util.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  cargoHash = "sha256-t6GVoMBCD0s36GhtqJu9Z2bwwq5P+beEObG+gSC+QUw=";

  postInstall = ''
    installManPage man/man*/*
    installShellCompletion --cmd zoxide \
      --bash contrib/completions/zoxide.bash \
      --fish contrib/completions/zoxide.fish \
      --zsh contrib/completions/_zoxide
  '';

  meta = with lib; {
    description = "Fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    changelog = "https://github.com/ajeetdsouza/zoxide/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h SuperSandro2000 ];
    mainProgram = "zoxide";
  };
}
