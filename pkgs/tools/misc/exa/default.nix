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

rustPlatform.buildRustPackage {
  pname = "exa";
  version = "unstable-2023-03-01";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "exa";
    rev = "c697d066702ab81ce0684fedb4c638e0fc0473e8";
    hash = "sha256-sSEnZLL0n7Aw72fPNJmyRxSLXCMC5uWwfTy2fpsuo6c=";
  };

  cargoHash = "sha256-/sxiQMWix4GR12IzuvXbx56mZhbcFpd+NJ49S2N+jzw=";

  nativeBuildInputs = [ cmake pkg-config installShellFiles pandoc ];
  buildInputs = [ zlib ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional gitSupport "git";

  outputs = [ "out" "man" ];

  postInstall = ''
    pandoc --standalone -f markdown -t man man/exa.1.md > man/exa.1
    pandoc --standalone -f markdown -t man man/exa_colors.5.md > man/exa_colors.5
    installManPage man/exa.1 man/exa_colors.5
    installShellCompletion \
      --bash completions/bash/exa \
      --fish completions/fish/exa.fish \
      --zsh completions/zsh/_exa
  '';

  meta = with lib; {
    description = "Replacement for 'ls' written in Rust";
    longDescription = ''
      exa is a modern replacement for ls. It uses colours for information by
      default, helping you distinguish between many types of files, such as
      whether you are the owner, or in the owning group. It also has extra
      features not present in the original ls, such as viewing the Git status
      for a directory, or recursing into directories with a tree view. exa is
      written in Rust, so it’s small, fast, and portable.
    '';
    changelog = "https://github.com/ogham/exa/releases";
    homepage = "https://the.exa.website";
    license = licenses.mit;
    maintainers = with maintainers; [ ehegnes lilyball globin fortuneteller2k ];
  };
}
