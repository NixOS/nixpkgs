
{ stdenv, gtk, pkgconfig, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "dragon-drop-${version}";
  version = "git-2014-08-14";

  src = fetchFromGitHub {
    owner = "mwh";
    repo = "dragon";
    rev = "a49d775dd9d43bd22cee4c1fd3e32ede0dc2e9c2";
    sha256 = "03vdbmqlbmk3j2ay1wy6snrm2y27faxz7qv81vyzjzngj345095a";
  };

  buildInputs = [ gtk pkgconfig ];

  installPhase = ''
    mkdir -p $out/bin
    mv dragon $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Simple drag-and-drop source/sink for X";
    homepage = "https://github.com/mwh/dragon";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
  };
}
