{
  lib,
  fetchFromGitHub,
  python3Packages,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "sabnzbd_exporter";
  version = "0.1.78";

  format = "other";

  src = fetchFromGitHub {
    owner = "msroest";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-BLqG2I7D/bqRj6+/LUKOimmTRTH/kRdukkGdOJT3+PA=";
  };

  propagatedBuildInputs = with python3Packages; [
    prometheus-client
    requests
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp sabnzbd_exporter.py $out/bin/

    mkdir -p $out/share/${pname}
    cp examples/* $out/share/${pname}/

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) sabnzbd;
  };

  meta = with lib; {
    description = "Prometheus exporter for sabnzbd";
    homepage = "https://github.com/msroest/sabnzbd_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ fugi ];
    platforms = platforms.all;
    mainProgram = "sabnzbd_exporter.py";
  };
}
