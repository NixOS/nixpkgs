{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "upx";
  version = "4.0.2";
  src = fetchFromGitHub {
    owner = "upx";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-5jqEdMlHmsD88kT/EGieL7DktppVdfWyJWGRNRKbRc4=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://upx.github.io/";
    description = "The Ultimate Packer for eXecutables";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
