args: with args;
stdenv.mkDerivation {
  name = "maven-2.1.0-bin";

  src = fetchurl {
    # TODO mirrors 
    url = http://apache.mirroring.de/maven/binaries/apache-maven-2.1.0-bin.zip;
    sha256 = "13xda2l05pqs7x8ig85i9dqbdbv970zfgqif4wgjz8nn36jbxpvd";
  };

  buildInputs = [ unzip ];

  phases = "unpackPhase installPhase";

  installPhase = "
    ensureDir \$out; mv * \$out
  ";

  meta = { 
      description = "Java build tool";
      homepage = "apache.org";
    };
}
