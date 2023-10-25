{lib, fetchgit, stdenv, fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-pretty-test";
  version = "v0.2.3";
  src = fetchgit {
    url = "https://github.com/josecelano/cargo-pretty-test";
    rev = "f167475b9c26791207a5c753df69229249825f61";
    hash = "sha256-xTsgisd2NTuWvEOoSLs4lvQhu4nkkkj/gPR+Wf7MOz0=";
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  doCheck = false;
  meta = with lib; {
    description = "A Rust command-line tool that prettifies the ugly cargo test output into a beautiful output";
    homepage = "https://github.com/josecelano/cargo-pretty-test";
    license = with licenses; [ gpl3 mit ];
    maintainers = with maintainers; [ organomagnesiumhalide ];
  };

}
