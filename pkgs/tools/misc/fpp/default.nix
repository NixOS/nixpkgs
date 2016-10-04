{ stdenv, fetchFromGitHub, python27Full }:

stdenv.mkDerivation rec {
  name = "fpp-${version}";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "PathPicker";
    rev = version;
    sha256 = "1mfyr9k5s3l1sg3c9vlyiqg8n1wwppzb981az2xaxqyk95wwl1sa";
  };

  postPatch = ''
    substituteInPlace fpp --replace 'PYTHONCMD="python"' 'PYTHONCMD="${python27Full.interpreter}"'
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
