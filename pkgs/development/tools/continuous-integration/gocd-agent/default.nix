{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "gocd-agent-${version}-${rev}";
  version = "16.9.0";
  rev = "4001";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-agent-${version}-${rev}.zip";
    sha256 = "1xcwwjf2khhng6v1y7dvi579y2j643al9n0x80m0c46qb9mzd04x";
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
