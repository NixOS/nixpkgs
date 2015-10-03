{ stdenv, fetchFromGitHub, curl, dmd, gcc }:

let version = "0.9.24"; in
stdenv.mkDerivation {
  name = "dub-${version}";

  src = fetchFromGitHub {
    sha256 = "1j2cs2mvaj6bjjicabq6lh97nx0v4b2k6pj4cmywki7hf3i1p8yy";
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

