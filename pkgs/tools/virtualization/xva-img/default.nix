{ stdenv, lib, cmake, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "xva-img";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "eriklax";
    repo = "xva-img";
    rev = version;
    sha256 = "1w3wrbrlgv7h2gdix2rmrmpjyla365kam5621a1aqjzwjqhjkwyq";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  meta = {
    maintainers = with lib.maintainers; [ lheckemann willibutz globin ];
    description = "Tool for converting Xen images to raw and back";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
