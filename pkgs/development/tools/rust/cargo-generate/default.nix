{ stdenv, fetchFromGitHub, rustPlatform, Security, openssl, pkgconfig, libiconv, curl }:

rustPlatform.buildRustPackage rec {
  name = "cargo-generate-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ashleygwilliams";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "0n6na6xq4bvs9hc7vc86qqmlrkv824qdmja27b21l2wz3l77r4jb";
  };

  cargoSha256 = "00fgzh1s63rr1vs3ahra604m81fc4imx3s09brw2y0n46syhwypi";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl  ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "cargo, make me a project";
    homepage = https://github.com/ashleygwilliams/cargo-generate;
    license = licenses.asl20;
    maintainers = [ maintainers.turbomack ];
    platforms = platforms.all;
  };
}
