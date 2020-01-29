{ stdenv, rustPlatform, fetchFromGitHub, llvmPackages, pkgconfig, less
, Security, libiconv, installShellFiles, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname   = "bat";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1cpa8dal4c27pnbmmrar4vqzcl4h0zf8x1zx1dlf0riavdg9n56y";
    fetchSubmodules = true;
  };

  cargoSha256 = "0d7h0kn41w6wm4w63vjy2i7r19jkansfvfjn7vgh2gqh5m60kal2";

  nativeBuildInputs = [ pkgconfig llvmPackages.libclang installShellFiles makeWrapper ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security libiconv ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  postInstall = ''
    installManPage doc/bat.1
    installShellCompletion assets/completions/bat.fish
  '';

  # Insert Nix-built `less` into PATH because the system-provided one may be too old to behave as
  # expected with certain flag combinations.
  postFixup = ''
    wrapProgram "$out/bin/bat" \
      --prefix PATH : "${stdenv.lib.makeBinPath [ less ]}"
  '';

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage    = https://github.com/sharkdp/bat;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir lilyball ];
    platforms   = platforms.all;
  };
}
