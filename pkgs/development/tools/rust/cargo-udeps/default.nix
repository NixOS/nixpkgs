{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, CoreServices, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.19";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0XE1w/FZmy0iMm5LI885S7F6GxgeHwh57t8N4hreSKw=";
  };

  cargoSha256 = "sha256-7pfGMCChOMSLlZ/bvaHfpksru5bCHfBQUN+sGyI1M8E=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security libiconv ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
  };
}
