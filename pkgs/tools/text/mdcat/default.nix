{ stdenv
, fetchFromGitHub
, rustPlatform
, pkgconfig
, asciidoctor
, openssl
, Security
, ansi2html
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "mdcat-${version}";
    hash = "sha256-i36MYTMkbSuWxxlWUDsyYMay/4Mg7M5jEFhHM60UrkM=";
  };

  nativeBuildInputs = [ pkgconfig asciidoctor installShellFiles ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  cargoSha256 = "sha256-mnDUIJhEGNoh3eq2Vhww1T/tpZh9RP+RxbRsBNrpOzw=";

  checkInputs = [ ansi2html ];
  # Skip tests that use the network and that include files.
  checkFlags = [
    "--skip magic::tests::detect_mimetype_of_larger_than_magic_param_bytes_max_length"
    "--skip magic::tests::detect_mimetype_of_magic_param_bytes_max_length"
    "--skip magic::tests::detect_mimetype_of_png_image"
    "--skip magic::tests::detect_mimetype_of_svg_image"
    "--skip resources::tests::read_url_with_http_url_fails_when_status_404"
    "--skip resources::tests::read_url_with_http_url_returns_content_when_status_200"
    "--skip iterm2_tests_render_md_samples_images_md"
  ];

  postInstall = ''
    installManPage $releaseDir/build/mdcat-*/out/mdcat.1
    installShellCompletion --bash $releaseDir/build/mdcat-*/out/completions/mdcat.bash
    installShellCompletion --fish $releaseDir/build/mdcat-*/out/completions/mdcat.fish
    installShellCompletion --zsh $releaseDir/build/mdcat-*/out/completions/_mdcat
  '';

  meta = with stdenv.lib; {
    description = "cat for markdown";
    homepage = "https://github.com/lunaryorn/mdcat";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ davidtwco ];
  };
}
