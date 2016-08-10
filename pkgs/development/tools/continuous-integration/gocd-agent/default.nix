{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "gocd-agent-${version}-${rev}";
  version = "16.7.0";
  rev = "3819";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-agent-${version}-${rev}.zip";
    sha256 = "24cc47099d2e9cc1d3983e1ab65957316770f791632e572189b1e6c0183403b7";
  };
  meta = with stdenv.lib; {
    description = "A continuous delivery server specializing in advanced workflow modeling and visualization";
    homepage = http://www.go.cd;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ grahamc swarren83 ];
  };

  buildInputs = [ unzip ];

  buildCommand = "
    unzip $src -d $out
    mv $out/go-agent-${version} $out/go-agent
  ";
}
