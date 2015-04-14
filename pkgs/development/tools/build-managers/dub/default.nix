{stdenv, fetchurl, curl, dmd, gcc, unzip }:

stdenv.mkDerivation {
  name = "dub-0.9.23";

  src = fetchurl {
    url = "https://github.com/D-Programming-Language/dub/archive/v0.9.23.tar.gz";
    sha256 = "7ecbce89c0e48b43705d7c48003394f383556f33562c4b5d884a786cd85814d1";
  };

  buildInputs = [ unzip curl ];

  propagatedBuildInputs = [ gcc dmd ];

  buildPhase = ''
      # Avoid that the version file is overwritten
      substituteInPlace build.sh \
          --replace source/dub/version_.d /dev/null
      ./build.sh
  '';

  installPhase = ''
      mkdir $out
      mkdir $out/bin
      cp bin/dub $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Build tool for D projects";
    homepage = http://code.dlang.org/;
    license = stdenv.lib.licenses.mit;
    platforms = platforms.unix;
  };
}

