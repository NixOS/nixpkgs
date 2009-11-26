{stdenv, fetchurl, jdk, makeWrapper}:

assert jdk != null;

stdenv.mkDerivation {
	name = "apache-maven-2.2.1";
	builder = ./builder.sh;
	src = fetchurl {
		url = mirror://apache/maven/binaries/apache-maven-2.2.1-bin.tar.gz;
		sha256 = "0xnk08ndf1jx458sr5dfr8rh7wi92kyn887vqyzjm1ka91cnb8xr";
	};
	
        buildInputs = [makeWrapper]; 
	inherit jdk;
}
