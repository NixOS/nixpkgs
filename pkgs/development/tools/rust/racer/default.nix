{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, substituteAll, Security }:

rustPlatform.buildRustPackage rec {
  pname = "racer";
  version = "2.1.40";

  src = fetchFromGitHub {
    owner = "racer-rust";
    repo = "racer";
    rev = "v${version}";
    sha256 = "sha256-8Is+RBfcXKbGSFzYoolLHs30rxlNI//xVGEOhxP2TV8=";
  };

  cargoSha256 = "sha256-iUomr9viCdZk4nV75/OP8vHtJpMbmy+pq1IbaA2lLmE=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP = 1;

  RUST_SRC_PATH = rustPlatform.rustLibSrc;
  postInstall = ''
    wrapProgram $out/bin/racer --set-default RUST_SRC_PATH ${rustPlatform.rustLibSrc}
  '';

  checkFlags = [
    "--skip nameres::test_do_file_search_std"
    "--skip util::test_get_rust_src_path_rustup_ok"
    "--skip util::test_get_rust_src_path_not_rust_source_tree"
    "--skip extern --skip completes_pub_fn --skip find_crate_doc"
    "--skip follows_use_local_package --skip follows_use_for_reexport"
    "--skip follows_rand_crate --skip get_completion_in_example_dir"
    "--skip test_resolve_global_path_in_modules"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/racer --version
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = "https://github.com/racer-rust/racer";
    license = licenses.mit;
    maintainers = with maintainers; [ jagajaga ma27 ];
  };
}
