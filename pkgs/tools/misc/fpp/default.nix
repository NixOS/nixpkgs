{ stdenv, fetchFromGitHub, bzip2, python27Full, makeWrapper }:

stdenv.mkDerivation rec {
  version = "0.7.1";
  name = "fpp-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "PathPicker";
    rev = version;
    sha256 = "1mfyr9k5s3l1sg3c9vlyiqg8n1wwppzb981az2xaxqyk95wwl1sa";
    name = "fpp-${version}";
  };

  buildInputs = [ bzip2 makeWrapper ];

  buildPhase = ''
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mv "fpp" "src" "$out"

    sed -i "s+PYTHONCMD=\"python\"+PYTHONCMD=\"${python27Full}/bin/python\"+g" "$out/fpp"

    ln -s "$out/fpp" "$out/bin/fpp"
  '';

  meta = {
    description = "CLI program that accepts piped input and presents files for selection";
    homepage = https://facebook.github.io/PathPicker/;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };
}
