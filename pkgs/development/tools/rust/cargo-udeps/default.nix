{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, CoreServices, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    sha256 = "0imvq63i3s9qmm0x8cbaknjap2yfmpzva3y0sxmgkcm8ajkvp114";
  };

  cargoSha256 = "196w9rgz4pwqvkiy839kqz765ljqx1k129w4nvxgxv3rcmy4lbzm";

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
  };
}
