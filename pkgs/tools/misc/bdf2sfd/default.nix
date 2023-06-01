{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "bdf2sfd";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "fcambus";
    repo = pname;
    rev = version;
    sha256 = "sha256-+CPULpy3mqZv0QaXS4kKYWKjifibtcQt7unKGOUTSV0=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "BDF to SFD converter";
    homepage = "https://github.com/fcambus/bdf2sfd";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
