{ lib, stdenv, fetchFromGitHub, rustPlatform, makeWrapper, perf
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flamegraph";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "flamegraph-rs";
    repo = "flamegraph";
    rev = "v${version}";
    sha256 = "0d6k2qr76p93na39j4zbcpc9kaswd806wrqhcwisqxdrcxrjbwhk";
  };

  cargoSha256 = "1qz4a1b58j3bv3akqvc3bcgvqq4bi8cbm3gzws6a52dz7ycrgq46";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ makeWrapper ];
  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/cargo-flamegraph \
      --suffix PATH ':' ${perf}/bin
    wrapProgram $out/bin/flamegraph \
      --suffix PATH ':' ${perf}/bin
  '';

  meta = with lib; {
    description = "Easy flamegraphs for Rust projects and everything else, without Perl or pipes <3";
    homepage = "https://github.com/ferrous-systems/flamegraph";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ killercup ];
    platforms = platforms.all;
  };
}
