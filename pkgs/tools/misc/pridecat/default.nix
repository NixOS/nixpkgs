{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pridecat";
  version = "92396b11";

  src = fetchFromGitHub {
    owner = "lunasorcery";
    repo = pname;
    rev = version;
    sha256 = "sha256-PyGLbbsh9lFXhzB1Xn8VQ9zilivycGFEIc7i8KXOxj8=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $pname $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/lunasorcery/pridecat";
    license = licenses.cc-by-nc-40;
    description = "Like cat, but more colorful";
    platforms = platforms.unix;
    maintainers = with maintainers; [ xfnw ];
  };
}
