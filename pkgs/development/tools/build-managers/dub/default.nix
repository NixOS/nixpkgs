{ stdenv, fetchFromGitHub, curl, dmd, gcc }:

stdenv.mkDerivation rec {
  name = "dub-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    sha256 = "1smzlfs5gjmrlghccdgn04qzy5b8l0xm8y2virayb2adrwqviscm";
    rev = "v${version}";
    repo = "dub";
    owner = "D-Programming-Language";
  };

  buildInputs = [ curl ];
  propagatedBuildInputs = [ gcc dmd ];

  buildPhase = ''
    # Avoid that the version file is overwritten
    substituteInPlace build.sh \
      --replace source/dub/version_.d /dev/null
    patchShebangs ./build.sh
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
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

