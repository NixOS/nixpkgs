{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "gocd-server-${version}-${rev}";
  version = "16.7.0";
  rev = "3819";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-server-${version}-${rev}.zip";
    sha256 = "3fae89741726eac69adab8dd64cd18918343188eeb43496e88d4f3abbe0998ad";
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
    mv $out/go-server-${version} $out/go-server
    mkdir -p $out/go-server/conf
  ";
}
