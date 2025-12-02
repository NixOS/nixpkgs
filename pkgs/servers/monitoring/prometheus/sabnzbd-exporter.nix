{
  lib,
  fetchFromGitHub,
  python3Packages,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "sabnzbd_exporter";
  version = "0.1.80";

  format = "other";

  src = fetchFromGitHub {
    owner = "msroest";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-9oL9Zbzzbr0hZjOdkaH86Tho6gaR+/6uAMreLwYzB8o=";
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

  meta = {
    description = "Prometheus exporter for sabnzbd";
    homepage = "https://github.com/msroest/sabnzbd_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fugi ];
    platforms = lib.platforms.all;
    mainProgram = "sabnzbd_exporter.py";
  };
}
