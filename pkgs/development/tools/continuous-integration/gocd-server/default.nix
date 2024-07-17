{
  lib,
  stdenv,
  fetchurl,
  unzip,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "gocd-server";
  version = "23.1.0";
  rev = "16079";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-server-${version}-${rev}.zip";
    sha256 = "sha256-//d6izGm1odE25H/PI5pn51FfUL4/6GbLwKUKAqZ3Kw=";
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
    maintainers = with maintainers; [
      grahamc
      swarren83
    ];
  };

  nativeBuildInputs = [ unzip ];

  passthru.tests = {
    inherit (nixosTests) gocd-server;
  };

  buildCommand = "
    unzip $src -d $out
    mv $out/go-server-${version} $out/go-server
    mkdir -p $out/go-server/conf
  ";
}
