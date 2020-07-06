{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, Security, ansi2html }:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "mdcat-${version}";
    hash = "sha256-1qxz6p7VaJ9eMcLQaTW/M4+Xo0WLihzyEAycbkjjPyA=";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  cargoSha256 = "sha256-/mAwlxed1MOFUA1jDSrgPzJuURbKzwucBWORVVHlrt8=";

  checkInputs = [ ansi2html ];
  checkPhase = ''
    # Skip tests that use the network and that include files.
    cargo test -- \
      --skip magic::tests::detect_mimetype_of_larger_than_magic_param_bytes_max_length \
      --skip magic::tests::detect_mimetype_of_magic_param_bytes_max_length \
      --skip magic::tests::detect_mimetype_of_png_image \
      --skip magic::tests::detect_mimetype_of_svg_image \
      --skip resources::tests::read_url_with_http_url_fails_when_status_404 \
      --skip resources::tests::read_url_with_http_url_returns_content_when_status_200 \
      --skip iterm2_tests_render_md_samples_images_md
  '';

  meta = with stdenv.lib; {
    description = "cat for markdown";
    homepage = "https://github.com/lunaryorn/mdcat";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.all;
  };
}
