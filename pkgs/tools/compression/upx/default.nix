{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "upx";
  version = "4.2.0";
  src = fetchFromGitHub {
    owner = "upx";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-PRfIJSjmeXjbslqWnKrHUPdOJfZU08nr4wXoAnP9qm0=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://upx.github.io/";
    description = "The Ultimate Packer for eXecutables";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "upx";
  };
}
