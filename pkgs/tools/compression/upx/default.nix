{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "upx";
  version = "4.0.1";
  src = fetchFromGitHub {
    owner = "upx";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-1aor3LbYlkxRCx+LqvGCDlplJclxmk9RyjZ90Yifw80=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://upx.github.io/";
    description = "The Ultimate Packer for eXecutables";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
