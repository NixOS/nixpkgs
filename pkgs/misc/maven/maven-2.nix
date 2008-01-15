args:
args.stdenv.mkDerivation {
  name = "maven-2.0.8-bin";

  src = args.fetchurl {
    # TODO mirrors 
    url = http://apache.linux-mirror.org/maven/binaries/apache-maven-2.0.8-bin.tar.bz2;
    sha256 = "1wasvqplw7xk04j38vsq94zbrlpdg2k4348bg8730snr6zgaasai";
  };

  phases = "unpackPhase installPhase";

  installPhase = "
    ensureDir \$out; mv * \$out
  ";

  buildInputs =(with args; []);

  meta = { 
      description = "Java build tool";
      homepage = "apache.org";
    };
}
