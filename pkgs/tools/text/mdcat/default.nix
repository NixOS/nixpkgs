{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, asciidoctor
, openssl
, Security
, ansi2html
, installShellFiles
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "mdcat-${version}";
    sha256 = "sha256-aJ7rL+EKa5zWmCmekVuRmdeOwTmVo0IQ+GJ8Ga4iTI0=";
  };

  patches = [
    # detect wezterm through TERM again which was removed in 0.23.1
    (fetchpatch {
      url = "https://github.com/lunaryorn/mdcat/commit/a897b223904748a47c277f7c9a07d59e7d5c916b.patch";
      sha256 = "sha256-tSeNyrlqoGvlfQ3xMRkvqZ7HajMvPCIk7kyt/sVjmTo=";
    })
  ];

  nativeBuildInputs = [ pkg-config asciidoctor installShellFiles ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  cargoSha256 = "sha256-r0dJ/lDOfRzEdwySR/eEvsrO8qn4g7ZIfpekiirUp3Q=";

  checkInputs = [ ansi2html ];
  # Skip tests that use the network and that include files.
  checkFlags = [
    "--skip magic::tests::detect_mimetype_of_larger_than_magic_param_bytes_max_length"
    "--skip magic::tests::detect_mimetype_of_magic_param_bytes_max_length"
    "--skip magic::tests::detect_mimetype_of_png_image"
    "--skip magic::tests::detect_mimetype_of_svg_image"
    "--skip resources::tests::read_url_with_http_url_fails_when_size_limit_is_exceeded"
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

  meta = with lib; {
    description = "cat for markdown";
    homepage = "https://github.com/lunaryorn/mdcat";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ davidtwco SuperSandro2000 ];
  };
}
