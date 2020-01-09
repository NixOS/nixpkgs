{ stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  pname = "fpp";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "PathPicker";
    rev = version;
    sha256 = "08p2xlz045fqyb0aj9pwwf2s5nb4b02i8zj81732q59yx5c6lrlv";
  };

  postPatch = ''
    substituteInPlace fpp --replace 'PYTHONCMD="python"' 'PYTHONCMD="${python3.interpreter}"'
  '';

  installPhase = ''
    mkdir -p $out/share/fpp $out/bin
    cp -r fpp src $out/share/fpp
    ln -s $out/share/fpp/fpp $out/bin/fpp
  '';

  meta = {
    description = "CLI program that accepts piped input and presents files for selection";
    homepage = https://facebook.github.io/PathPicker/;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };
}
