{ stdenv, fetchFromGitHub, curl, dmd, gcc }:

stdenv.mkDerivation rec {
  name = "dub-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    sha256 = "07s52hmh9jc3i4jfx4j4a91m44qrr933pwfwczzijhybj2wmpjhh";
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

