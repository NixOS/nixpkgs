{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, Security, ansi2html }:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "mdcat-${version}";
    sha256 = "10svzq7656lynfcgnbyaibfvv48i4289ymxfc0bn0212biyrl1zb";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  cargoSha256 = "05nh3dfr7mdw21sdavyyjhr8sa4jcfqzwizbgg92ib7r834ir3m0";

  checkInputs = [ ansi2html ];
  checkPhase = ''
    # Skip tests that use the network and that include files.
    cargo test -- --skip terminal::iterm2 \
      --skip magic::tests::detect_mimetype_of_svg_image \
      --skip magic::tests::detect_mimetype_of_png_image \
      --skip resources::tests::read_url_with_http_url_fails_when_status_404 \
      --skip resources::tests::read_url_with_http_url_returns_content_when_status_200
  '';

  meta = with stdenv.lib; {
    description = "cat for markdown";
    homepage = "https://github.com/lunaryorn/mdcat";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.all;
  };
}
