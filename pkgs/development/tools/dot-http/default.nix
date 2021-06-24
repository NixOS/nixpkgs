{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "dot-http";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "bayne";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s2q4kdldhb5gd14g2h6vzrbjgbbbs9zp2dgmna0rhk1h4qv0mml";
  };

  cargoSha256 = "0an3hskq1k2j4gdn8wvhfb9pqsc34ibs5bv7sjznkp5jma6fdr9w";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    libiconv Security
  ];

  meta = with lib; {
    description = "Text-based scriptable HTTP client";
    homepage = "https://github.com/bayne/dot-http";
    license = licenses.asl20;
    maintainers = with maintainers; [ mredaelli ];
  };
}
