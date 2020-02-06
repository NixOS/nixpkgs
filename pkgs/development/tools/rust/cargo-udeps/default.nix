{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, CoreServices, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lrfnrxqmpp06fargb5s5fc9y4w4h0ahbd7rgibqqx1la23l9r5q";
  };

  cargoSha256 = "18rwzcsrlwds3nx90y03dkqm1hl4dpvclm32i9zy9bhpm9hkypwr";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security libiconv ];

  meta = with stdenv.lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
    platforms = platforms.all;
  };
}
