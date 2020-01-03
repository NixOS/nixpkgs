{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "gocd-server-${version}-${rev}";
  version = "19.3.0";
  rev = "8959";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-server-${version}-${rev}.zip";
    sha256 = "0c30qzd6awlw0zx91rk6na0mmgykqkgrw9ychx18ivjwma0hr0sc";
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
