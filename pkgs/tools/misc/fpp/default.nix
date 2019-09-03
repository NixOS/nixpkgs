{ stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  pname = "fpp";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "PathPicker";
    rev = version;
    sha256 = "00916xx4scd4xr9zxqkyhilczi27f2qm5y042592wr79ddix4n9v";
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
