{ lib
, gitSupport ? true
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, pandoc
, pkg-config
, zlib
, Security
, libiconv
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "eza";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "eza-community";
    repo = "eza";
    rev = "v${version}";
    hash = "sha256-qA9oXAHJyEf5yI1AlofAKs5fNpNQev9FlY/GHNsfo2Q=";
  };

  cargoHash = "sha256-xcw2fhEnUheDSJ5vE7Z1EqahVdCluClC7TmC1PFUUV4=";

  nativeBuildInputs = [ cmake pkg-config installShellFiles pandoc ];
  buildInputs = [ zlib ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional gitSupport "git";

  outputs = [ "out" "man" ];

  postInstall = ''
    pandoc --standalone -f markdown -t man man/eza.1.md > man/eza.1
    pandoc --standalone -f markdown -t man man/eza_colors.5.md > man/eza_colors.5
    pandoc --standalone -f markdown -t man man/eza_colors-explanation.5.md > man/eza_colors-explanation.5
    installManPage man/eza.1 man/eza_colors.5 man/eza_colors-explanation.5
    installShellCompletion \
      --bash completions/bash/eza \
      --fish completions/fish/eza.fish \
      --zsh completions/zsh/_eza
  '';

  meta = with lib; {
    description = "A modern, maintained replacement for ls";
    longDescription = ''
      eza is a modern replacement for ls. It uses colours for information by
      default, helping you distinguish between many types of files, such as
      whether you are the owner, or in the owning group. It also has extra
      features not present in the original ls, such as viewing the Git status
      for a directory, or recursing into directories with a tree view. eza is
      written in Rust, so it’s small, fast, and portable.
    '';
    homepage = "https://github.com/eza-community/eza";
    changelog = "https://github.com/eza-community/eza/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "eza";
    maintainers = with maintainers; [ cafkafk ];
    platforms = platforms.unix ++ platforms.windows;
  };
}
