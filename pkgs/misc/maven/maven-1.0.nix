{stdenv, fetchurl, jdk}:

assert jdk != null;

stdenv.mkDerivation {
	name = "maven-1.0.2";
        mavenBinary = "maven";
	builder = ./builder.sh;
	src = fetchurl {
		url = http://apache.cs.uu.nl/dist/maven/binaries/maven-1.0.2.tar.bz2;
		md5 = "81a6b4393e550635efe19e95cea38718";
	};
	makeWrapper = ../../build-support/make-wrapper/make-wrapper.sh;
	
	inherit jdk;
}
