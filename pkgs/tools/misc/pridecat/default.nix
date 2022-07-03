{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "pridecat";
  version = "unstable-2020-06-19";

  src = fetchFromGitHub {
    owner = "lunasorcery";
    repo = "pridecat";
    rev = "92396b11459e7a4b5e8ff511e99d18d7a1589c96";
    sha256 = "sha256-PyGLbbsh9lFXhzB1Xn8VQ9zilivycGFEIc7i8KXOxj8=";
  };

  # fixes the install path in the Makefile
  patches = [ ./fix_install.patch ];

  meta = with lib; {
    description = "Like cat, but more colorful";
    homepage = "https://github.com/lunasorcery/pridecat";
    license = licenses.cc-by-nc-sa-40;
    maintainers = with maintainers; [ lunarequest ];
  };
}
