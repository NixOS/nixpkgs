{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "gocd-agent";
  version = "23.1.0";
  rev = "16079";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-agent-${version}-${rev}.zip";
    sha256 = "sha256-L2MOkbVHoQu99lKrbnsNkhuU0SZ8VANSK72GZrGLbiQ=";
  };
  meta = with lib; {
    description = "Continuous delivery server specializing in advanced workflow modeling and visualization";
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
