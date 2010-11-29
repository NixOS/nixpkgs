{stdenv, fetchurl, jdk, makeWrapper}:

assert jdk != null;

stdenv.mkDerivation {
	name = "apache-maven-3.0";
	builder = ./builder.sh;
	src = fetchurl {
		url = mirror://apache/maven/binaries/apache-maven-3.0-bin.tar.gz;
		sha256 = "18i7vf7w79pvga4k0plixv2ppdvm476cgikaxxnar1fac5v0qsh4";
	};
	
        buildInputs = [makeWrapper]; 
	inherit jdk;
}
