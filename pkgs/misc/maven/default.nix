{stdenv, fetchurl, jdk, makeWrapper}:

assert jdk != null;

stdenv.mkDerivation {
	name = "apache-maven-3.0.4";
	builder = ./builder.sh;
	src = fetchurl {
		url = mirror://apache/maven/binaries/apache-maven-3.0.4-bin.tar.gz;
		sha256 = "0bxa7x8ifm8590nxifhsh3sxzm6aicbczyx21vibg3606ih8fnnk";
	};
	
        buildInputs = [makeWrapper]; 
	inherit jdk;
}
