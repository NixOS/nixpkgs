{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "dlfcn";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "dlfcn-win32";
    repo = "dlfcn-win32";
    rev = "v${version}";
    sha256 = "sha256-ljVTMBiGp8TPufrQcK4zQtcVH1To4zcfBAbUOb+v910=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/dlfcn-win32/dlfcn-win32";
    description = "Set of functions that allows runtime dynamic library loading";
    license = licenses.mit;
    platforms = platforms.windows;
    maintainers = with maintainers; [ marius851000 ];
  };
}
