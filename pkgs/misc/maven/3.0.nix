{stdenv, fetchurl, jdk, makeWrapper}:

assert jdk != null;

stdenv.mkDerivation {
	name = "apache-maven-3.0.3";
	builder = ./builder.sh;
	src = fetchurl {
		url = mirror://apache/maven/binaries/apache-maven-3.0.3-bin.tar.gz;
		sha256 = "b845479bd5d6d821210d3530c65da628a118abedd176492741e1d9bc5e400e2a";
	};
	
        buildInputs = [makeWrapper]; 
	inherit jdk;
}
