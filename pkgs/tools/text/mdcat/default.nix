{
  lib,
  curl,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  asciidoctor,
  openssl,
  ansi2html,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "mdcat";
    rev = "mdcat-${version}";
    hash = "sha256-j6BFXx5cyjE3+fo1gGKlqpsxrm3i9HfQ9tJGNNjjLwo=";
  };

  patches = [
    ./fix-clippy.diff
  ];

  nativeBuildInputs = [
    pkg-config
    asciidoctor
    installShellFiles
  ];
  buildInputs = [
    curl
    openssl
  ];

  cargoHash = "sha256-8A0RLbFkh3fruZAbjJzipQvuFLchqIRovPcc6MSKdOc=";

  nativeCheckInputs = [ ansi2html ];
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
    ln -sr $out/bin/{mdcat,mdless}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for bin in mdcat mdless; do
      installShellCompletion --cmd $bin \
        --bash <($out/bin/$bin --completions bash) \
        --fish <($out/bin/$bin --completions fish) \
        --zsh <($out/bin/$bin --completions zsh)
    done
  '';

  meta = with lib; {
    description = "cat for markdown";
    homepage = "https://github.com/swsnr/mdcat";
    changelog = "https://github.com/swsnr/mdcat/releases/tag/mdcat-${version}";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
