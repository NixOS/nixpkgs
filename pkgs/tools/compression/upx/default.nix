{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "upx";
  version = "4.1.0";
  src = fetchFromGitHub {
    owner = "upx";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-pHJypO+sK7+ytM7yJxJpfBJHTYpGc9nr/JiFGd7hlJM=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://upx.github.io/";
    description = "The Ultimate Packer for eXecutables";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
