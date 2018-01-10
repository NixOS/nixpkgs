{ stdenv, fetchFromGitHub, python27 }:

stdenv.mkDerivation rec {
  name = "fpp-${version}";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "PathPicker";
    rev = version;
    sha256 = "03n8sc2fvs2vk46jv6qfkjbyqz85yxnphvabji7qnmd3jv631w47";
  };

  postPatch = ''
    substituteInPlace fpp --replace 'PYTHONCMD="python"' 'PYTHONCMD="${python27.interpreter}"'
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
