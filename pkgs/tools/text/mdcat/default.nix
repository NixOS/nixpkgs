{ lib
, stdenv
, fetchFromGitea
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
  version = "0.26.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "flausch";
    repo = "mdcat";
    rev = "mdcat-${version}";
    sha256 = "sha256-vB49EwQltonR9Uw8RRMZTPR4WkcylnIqiE0/8+t2R1Q=";
  };

  nativeBuildInputs = [ pkg-config asciidoctor installShellFiles ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  cargoSha256 = "sha256-v52ob5l5HiiZZmo88D9/ldFi0170/BuPzgKIt9ctSgU=";

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
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ davidtwco SuperSandro2000 ];
  };
}
