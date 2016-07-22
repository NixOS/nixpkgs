{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "gocd-agent-${version}-${rev}";
  version = "16.5.0";
  rev = "3305";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-agent-${version}-${rev}.zip";
    sha256 = "2cb988d36ec747b2917f3be040b430f2a8289c07353a6b6bdc95bf741fa1ed97";
  };
  meta = with stdenv.lib; {
    description = "A continuous delivery server specializing in advanced workflow modeling and visualization";
    homepage = http://www.go.cd;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ swarren83 ];
  };

  buildInputs = [ unzip ];

  buildCommand = "
    unzip $src -d $out
    mv $out/go-agent-${version} $out/go-agent
  ";
}
