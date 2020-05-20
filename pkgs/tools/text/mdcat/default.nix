{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, Security, ansi2html }:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "mdcat-${version}";
    sha256 = "04kmlsg13mqlcpi5as760ycrqmznaaj7840hzxkri29mj05mgzq0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  cargoSha256 = "1lpivksjiyyg5ap97ccpq30q4n09sf259ds0hj49wihjrgd0h0c7";

  checkInputs = [ ansi2html ];
  checkPhase = ''
    # Skip tests that use the network and that include files.
    cargo test -- --skip terminal::iterm2 \
      --skip magic::tests::detect_mimetype_of_svg_image \
      --skip magic::tests::detect_mimetype_of_png_image \
      --skip magic::tests::detect_mimetype_of_larger_than_magic_param_bytes_max_length \
      --skip magic::tests::detect_mimetype_of_magic_param_bytes_max_length \
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
