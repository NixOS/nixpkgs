{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, openssl, pkg-config, libiconv, curl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-generate";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "ashleygwilliams";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "1w5vfifajp0aj7hw4mmvdb5g9zir7fs26z0fy8bsz9xz20bspkfk";
  };

  cargoSha256 = "1l843xssrb6liimxipll4mbn2rlfypsqfmvisx1k15ysbgjcf96p";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl  ]
    ++ lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  doCheck = false;

  meta = with lib; {
    description = "cargo, make me a project";
    homepage = "https://github.com/ashleygwilliams/cargo-generate";
    license = licenses.asl20;
    maintainers = [ maintainers.turbomack ];
  };
}
