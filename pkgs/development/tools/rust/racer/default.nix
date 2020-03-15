{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, substituteAll, Security }:

rustPlatform.buildRustPackage rec {
  pname = "racer";
  version = "2.1.30";

  src = fetchFromGitHub {
    owner = "racer-rust";
    repo = "racer";
    rev = "c2b0080243fefdad7f7b223e8a7fdef3e1f0fa77";
    sha256 = "0svvdkfqpk2rw0wxyrhkxy553k55lg7jxc0ly4w1195iwv14ad3y";
  };

  cargoSha256 = "0zaqa89z3nf23s2q1jpmfz4lygh4zq9ymql71d748fgjy9psr449";

  buildInputs = [ makeWrapper ]
                ++ stdenv.lib.optional stdenv.isDarwin Security;

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP=1;

  RUST_SRC_PATH = rustPlatform.rustcSrc;
  postInstall = ''
    wrapProgram $out/bin/racer --set-default RUST_SRC_PATH ${rustPlatform.rustcSrc}
  '';

  checkPhase = ''
    cargo test -- \
      --skip nameres::test_do_file_search_std \
      --skip util::test_get_rust_src_path_rustup_ok \
      --skip util::test_get_rust_src_path_not_rust_source_tree \
      --skip extern --skip completes_pub_fn --skip find_crate_doc \
      --skip follows_use_local_package --skip follows_use_for_reexport \
      --skip follows_rand_crate --skip get_completion_in_example_dir \
      --skip test_resolve_global_path_in_modules
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/racer --version
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/racer-rust/racer;
    license = licenses.mit;
    maintainers = with maintainers; [ jagajaga ma27 ];
    platforms = platforms.all;
  };
}
