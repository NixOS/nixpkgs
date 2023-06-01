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
}:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "mdcat";
    rev = "mdcat-${version}";
    sha256 = "sha256-S47xJmwOCDrJJSYP9WiUKFWR9UZDNgY3mc/fTHaKsvA=";
  };

  nativeBuildInputs = [ pkg-config asciidoctor installShellFiles ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  cargoSha256 = "sha256-g/Il3Sff9NtEfGTXBOGyRw6/GXje9kVwco0URyhv4TI=";

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

    for bin in mdcat mdless; do
      installShellCompletion \
        --bash $releaseDir/build/mdcat-*/out/completions/$bin.bash \
        --fish $releaseDir/build/mdcat-*/out/completions/$bin.fish \
        --zsh $releaseDir/build/mdcat-*/out/completions/_$bin
    done
  '';

  meta = with lib; {
    description = "cat for markdown";
    homepage = "https://github.com/swsnr/mdcat";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
