{ lib, fetchFromGitHub, rustPlatform, stdenv, libbfd, libopcodes, libunwind }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bolero";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "camshaft";
    repo = "bolero";
    rev = "${pname}-v${version}";
    sha256 = "1p8g8av0l1qsmq09m0nwyyryk1v5bbah5izl4hf80ivi41mywkyi";
  };

  cargoLock.lockFile = ./Cargo.lock;
  postPatch = "cp ${./Cargo.lock} Cargo.lock";

  buildInputs = [ libbfd libopcodes libunwind ];

  meta = with lib; {
    description = "Fuzzing and property testing front-end framework for Rust";
    homepage = "https://github.com/camshaft/cargo-bolero";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.ekleog ];
  };
}
