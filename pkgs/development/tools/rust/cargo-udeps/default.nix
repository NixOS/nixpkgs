{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, CoreServices, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wh8w5p9rb9cqgpmclaywfsz3ckfi9mw38hhg31w7hkgjmqalyj9";
  };

  cargoSha256 = "0g56rvan0p57hkl00warx4ig7a54g0qw6p2gkwn9yxi6p3p2wddj";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security libiconv ];

  # Requires network access
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
    platforms = platforms.all;
  };
}
