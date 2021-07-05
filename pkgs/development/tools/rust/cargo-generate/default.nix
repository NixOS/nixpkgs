{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, openssl, pkg-config, libiconv, curl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-generate";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "ashleygwilliams";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "0mclrkp3rbm9cs5g2x6k8dhbhdq53db16kfr3p07zb5iiyksvk5g";
  };

  cargoSha256 = "0pyfrd7cf6g71v660vk0q2wgwa4ga0ljwf5dzcszrgsjay3nnl7f";

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
