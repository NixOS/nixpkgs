{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "krapslog";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "acj";
    repo = "krapslog-rs";
    rev = version;
    sha256 = "sha256-Y5OdRi9OhVeT04BnHCCcNBr1G9vxSFwvNl1aL38AFWQ=";
  };

  cargoHash = "sha256-fdrcV4XmxaWiAVOL51sRUfTEDnnCKduYgj7I5unLpRI=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Visualize a log file with sparklines";
    homepage = "https://github.com/acj/krapslog-rs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto ];
  };
}
