{ stdenv, fetchFromGitHub, rustPlatform, Security, openssl, pkgconfig, libiconv, curl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-generate";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ashleygwilliams";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "07hklya22ixklb44f3qp6yyh5d03a7rjcn0g76icqr36hvcjyjjh";
  };

  cargoSha256 = "1rsk9j1ij53dz4gakxwdppgmv12lmyj0ihh9qypdbgskvyq3a2j9";

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
