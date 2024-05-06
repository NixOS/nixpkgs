{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "lg-webos-remote-control";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "madmicio";
    repo = "LG-WebOS-Remote-Control";
    rev = version;
    hash = "sha256-ICOAi8q8dWrBFCv18JYSWc6MIwqxfDXOcc6kCKLGehs=";
  };

  npmDepsHash = "sha256-kN+i0ic1JWs6kqnAliiO4yVMDXwfZaQsRGKeV9A0MxE=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/lg-remote-control.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "lg-remote-control.js";

  meta = with lib; {
    description = "Remote Control for LG TV WebOS";
    homepage = "https://github.com/madmicio/LG-WebOS-Remote-Control";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.all;
  };
}
