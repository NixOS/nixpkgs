{ stdenv, lib, cmake, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "xva-img";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "eriklax";
    repo = "xva-img";
    rev = version;
    sha256 = "sha256-QHCKGsHSMT2P64No1IUCjenm1XZMSgEvsJGJOyHFZS8=";
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
