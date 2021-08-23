{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "gocd-agent";
  version = "21.2.0-12498";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}/generic/go-agent-${version}.zip";
    sha256 = "1wirhkap4y8hr6krp3kx6kzz5p8zj654b8n8y87vy65rih2khphh";
  };

  meta = with lib; {
    description = "A continuous delivery server specializing in advanced workflow modeling and visualization";
    homepage = "http://www.go.cd";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ grahamc swarren83 ];
  };

  nativeBuildInputs = [ unzip ];

  buildCommand =
    let
      versionParts = lib.splitString "-" version;
      baseVersion = lib.lists.elemAt versionParts 0;
    in
    ''
      unzip $src -d $out
      mv $out/go-agent-${baseVersion} $out/go-agent
    '';
}
