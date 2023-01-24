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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
    sha256 = "sha256-easHqXEHMrRqLmD7GMudoMGRnFOLsnRrgivVaYfQn8k=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  postPatch = lib.optionalString withFzf ''
    substituteInPlace src/util.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  cargoSha256 = "sha256-6SGzMEYQIGDabIlCUmHky34wGMrAkOrweF7VTzzrUPE=";

  postInstall = ''
    installManPage man/man*/*
    installShellCompletion --cmd zoxide \
      --bash contrib/completions/zoxide.bash \
      --fish contrib/completions/zoxide.fish \
      --zsh contrib/completions/_zoxide
  '';

  meta = with lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    changelog = "https://github.com/ajeetdsouza/zoxide/raw/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h SuperSandro2000 ];
  };
}
