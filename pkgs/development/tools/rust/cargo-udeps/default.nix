{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, CoreServices, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xmlpn4j5lhbzd9icb3nga5irfknmxfml9sn677d9z6fwfjfpa0l";
  };

  cargoSha256 = "1si95pdhbi6pa94gh9vip95n37im6kcfsgslpnibck2157pg4la6";

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
