{ lib, stdenv, fetchFromGitHub, rustPlatform, makeWrapper, perf
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flamegraph";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "flamegraph-rs";
    repo = "flamegraph";
    rev = "v${version}";
    sha256 = "1avjq36wnm0gd5zkkv1c8hj8j51ah1prlifadjhpaf788rsng9w1";
  };

  cargoSha256 = "1kmxpzgv24hf66gzyapxy48gzwqi0p0jvzv829sfdlp00qgj1kp4";

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
