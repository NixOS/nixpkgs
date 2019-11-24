{ stdenv, fetchFromGitHub, rustPlatform, Security, openssl, pkgconfig, libiconv, curl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-generate";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ashleygwilliams";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "09276jrb0a735v6p06wz94kbk8bblwpca13vpvy8n0jjmqack2xb";
  };

  cargoSha256 = "1gbxfmhwzpxm0gs3zwzs010j0ndi5aw6xsvvngg0h1lpwg9ypnbr";

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
