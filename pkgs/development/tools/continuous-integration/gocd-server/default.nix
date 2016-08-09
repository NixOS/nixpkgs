{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "gocd-server-${version}-${rev}";
  version = "16.6.0";
  rev = "3590";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-server-${version}-${rev}.zip";
    sha256 = "6e737c8b419544deb5089e9a2540892a6faec73c962ee7c4e526a799056acca1";
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
