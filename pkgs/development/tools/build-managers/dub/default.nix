{stdenv, fetchurl, curl, dmd, gcc, unzip}:

stdenv.mkDerivation {
  name = "dub-0.9.22";

  src = fetchurl {
    url = "https://github.com/rejectedsoftware/dub/archive/v0.9.22.tar.gz";
    sha256 = "0vhn96ybbsfflldlbyc17rmwb7bz21slbm189k5glyfr9nnp4cir";
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

