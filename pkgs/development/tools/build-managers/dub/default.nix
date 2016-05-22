{ stdenv, fetchFromGitHub, curl, dmd, gcc }:

stdenv.mkDerivation rec {
  name = "dub-${version}";
  version = "0.9.25";

  src = fetchFromGitHub {
    sha256 = "0cb4kx72fvk6vfqkk0mrp6fvv512xhw03dq2dn9lng0daydvdcim";
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
    inherit version;
    description = "Build tool for D projects";
    homepage = http://code.dlang.org/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

