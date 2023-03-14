{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "gocd-agent";
  version = "22.2.0";
  rev = "14697";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-agent-${version}-${rev}.zip";
    sha256 = "sha256-0nEJ0cNotVohT+eYRXV/XP4WfGx3UnPDqCBgklAvsnk=";
  };
  meta = with lib; {
    description = "A continuous delivery server specializing in advanced workflow modeling and visualization";
    homepage = "http://www.go.cd";
    license = licenses.asl20;
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    maintainers = with maintainers; [ grahamc swarren83 ];
  };

  nativeBuildInputs = [ unzip ];

  buildCommand = "
    unzip $src -d $out
    mv $out/go-agent-${version} $out/go-agent
  ";
}
