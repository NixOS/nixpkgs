{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "lg-webos-remote-control";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "madmicio";
    repo = "LG-WebOS-Remote-Control";
    rev = version;
    hash = "sha256-WPaT9ZxNjhm53+9PQnx50GGkI46IIhcHEriyE125fV0=";
  };

  npmDepsHash = "sha256-kN+i0ic1JWs6kqnAliiO4yVMDXwfZaQsRGKeV9A0MxE=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/lg-remote-control.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "lg-remote-control.js";

  meta = {
    description = "Remote Control for LG TV WebOS";
    homepage = "https://github.com/madmicio/LG-WebOS-Remote-Control";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ k900 ];
    platforms = lib.platforms.all;
  };
}
