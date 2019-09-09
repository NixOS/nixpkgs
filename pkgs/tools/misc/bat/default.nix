{ stdenv, rustPlatform, fetchFromGitHub, llvmPackages, pkgconfig, zlib
, Security, libiconv
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

  nativeBuildInputs = [ pkgconfig llvmPackages.libclang zlib ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security libiconv ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  postInstall = ''
    install -m 444 -Dt $out/share/man/man1 doc/bat.1
    install -m 444 -Dt $out/share/fish/vendor_completions.d assets/completions/bat.fish
  '';

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage    = https://github.com/sharkdp/bat;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir lilyball ];
    platforms   = platforms.all;
  };
}
