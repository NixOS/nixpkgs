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
  version = "unstable-2023-11-20";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "3022cf3686b85288e6fbecb2bd23ad113fd83f3b";
    sha256 = "sha256-ut+/F7cQ5Xamb7T45a78i0mjqnNG9/73jPNaDLxzAx8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  postPatch = lib.optionalString withFzf ''
    substituteInPlace src/util.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  cargoSha256 = "sha256-JRWlHwPFqNC/IIKQqRQszx4HHW1XsmROA67KmnxkmWQ=";

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
    # changelog = "https://github.com/ajeetdsouza/zoxide/raw/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h SuperSandro2000 ];
    mainProgram = "zoxide";
  };
}
