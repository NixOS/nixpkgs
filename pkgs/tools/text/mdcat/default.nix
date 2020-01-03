{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, Security, ansi2html }:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "mdcat-${version}";
    sha256 = "1q8h6pc1i89j1zl4s234inl9v95vsdrry1fzlis89sl2mnbv8ywy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ (stdenv.lib.optional stdenv.isDarwin Security) openssl ];

  cargoSha256 = "1hxsfls6fpllc9yg5ib3qz6pa62j1y1va8a6356j6812csk4ifnn";

  checkInputs = [ ansi2html ];
  checkPhase = ''
    # Skip tests that use the network and that include files.
    cargo test -- --skip terminal::iterm2 --skip terminal::resources::tests::remote \
      --skip magic::tests::detect_mimetype_of_svg_image \
      --skip magic::tests::detect_mimetype_of_png_image
  '';

  meta = with stdenv.lib; {
    description = "cat for markdown";
    homepage = https://github.com/lunaryorn/mdcat;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.all;
  };
}
