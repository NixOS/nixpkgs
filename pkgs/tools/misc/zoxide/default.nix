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
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "refs/tags/v${version}";
    hash = "sha256-dxdBXoV9X2oA5ig6PK/GuNLRRzO1E0zHJwVFQp7GY2g=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  postPatch = lib.optionalString withFzf ''
    substituteInPlace src/util.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  cargoHash = "sha256-fNAS2pCt3Oxz8qyn6GnJpx3Tq/EyPzbwns28tKeMqf0=";

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
    changelog = "https://github.com/ajeetdsouza/zoxide/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h SuperSandro2000 ];
    mainProgram = "zoxide";
  };
}
