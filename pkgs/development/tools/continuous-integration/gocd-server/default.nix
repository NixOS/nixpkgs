{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "gocd-server-${version}-${rev}";
  version = "16.5.0";
  rev = "3305";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-server-${version}-${rev}.zip";
    sha256 = "41139051f419dc340a5c05c76e5de06eeef3516526341f377ac77532511bfa2c";
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
    mv $out/go-server-${version} $out/go-server
    mkdir -p $out/go-server/conf
  ";
}
