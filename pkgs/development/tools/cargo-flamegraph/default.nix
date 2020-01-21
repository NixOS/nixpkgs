{ lib, stdenv, fetchFromGitHub, rustPlatform, makeWrapper, perf
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flamegraph";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "ferrous-systems";
    repo = "flamegraph";
    rev = version;
    sha256 = "1s0jnj78fqz5hlgq656rr2s9ykmia51b89iffadiw6c2aw4fhv1a";
  };

  cargoSha256 = "0kmw2n4j5bisac0bv3npbwfz2z00ncd6w8ichwaz5hac5mi1a72f";

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
    homepage = https://github.com/ferrous-systems/flamegraph;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ killercup ];
    platforms = platforms.all;
  };
}
