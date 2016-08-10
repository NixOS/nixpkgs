{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "gocd-agent-${version}-${rev}";
  version = "16.6.0";
  rev = "3590";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-agent-${version}-${rev}.zip";
    sha256 = "ee076c62b388a6ed88d5065f18a4a96cb0d3161f693c16f920d85886d295ff27";
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
