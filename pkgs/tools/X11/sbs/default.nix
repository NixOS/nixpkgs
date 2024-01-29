{ lib, stdenv, fetchFromGitHub, libX11, imlib2, libXinerama, pkg-config }:

stdenv.mkDerivation rec {
  pname = "sbs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "onur-ozkan";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-Zgu9W/3LwHF/fyaPlxmV/2LdxilO1tU0JY/esLnJVGY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ imlib2 libX11 libXinerama ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple background setter with 200 lines of code";
    homepage = "https://github.com/onur-ozkan/sbs";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onur-ozkan ];
    mainProgram = "sbs";
  };
}
