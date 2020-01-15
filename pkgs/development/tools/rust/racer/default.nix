{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, substituteAll, Security }:

rustPlatform.buildRustPackage rec {
  pname = "racer";
  version = "2.1.22";

  src = fetchFromGitHub {
    owner = "racer-rust";
    repo = "racer";
    rev = "v${version}";
    sha256 = "1n808h4jqxkvpjwmj8jgi4y5is5zvr8vn42mwb3yi13mix32cysa";
  };

  cargoSha256 = "0njaa9vk2i9g1c6sq20b7ls97nl532rfv3is7d8dwz51nrwk6jxs";

  buildInputs = [ makeWrapper ]
                ++ stdenv.lib.optional stdenv.isDarwin Security;

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP=1;

  RUST_SRC_PATH = rustPlatform.rustcSrc;
  postInstall = ''
    wrapProgram $out/bin/racer --set-default RUST_SRC_PATH $rustcSrc
  '';

  checkPhase = ''
    cargo test -- \
      --skip nameres::test_do_file_search_std \
      --skip util::test_get_rust_src_path_rustup_ok \
      --skip util::test_get_rust_src_path_not_rust_source_tree \
      --skip extern --skip completes_pub_fn --skip find_crate_doc \
      --skip follows_use_local_package --skip follows_use_for_reexport \
      --skip follows_rand_crate --skip get_completion_in_example_dir
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/racer --version
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/racer-rust/racer;
    license = licenses.mit;
    maintainers = with maintainers; [ jagajaga ];
    platforms = platforms.all;
  };
}
