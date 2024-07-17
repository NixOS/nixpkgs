{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "sabnzbd_exporter";
  version = "0.1.70";

  format = "other";

  src = fetchFromGitHub {
    owner = "msroest";
    repo = pname;
    rev = version;
    hash = "sha256-FkZAWIIlGX2VxRL3WS5J9lBgToQGbEQUqvf0xcdvynk=";
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

  meta = with lib; {
    description = "Prometheus exporter for sabnzbd";
    homepage = "https://github.com/msroest/sabnzbd_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ fugi ];
    platforms = platforms.all;
    mainProgram = "sabnzbd_exporter.py";
  };
}
