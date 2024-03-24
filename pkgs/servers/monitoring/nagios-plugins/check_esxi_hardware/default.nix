{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "check_esxi_hardware";
  version = "20200710";
  format = "other";

  src = fetchFromGitHub {
    owner = "Napsty";
    repo = "check_esxi_hardware";
    rev = "refs/tags/${version}";
    sha256 = "EC6np/01S+5SA2H9z5psJ9Pq/YoEyGdHL9wHUKKsNas=";
  };

  dontBuild = true;

  dependencies = with python3Packages; [
    pywbem
    requests
    setuptools
  ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -Dm755 check_esxi_hardware.py $out/bin/check_esxi_hardware
    install -Dm644 -t $out/share/doc/${pname} README.md

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.claudiokuenzler.com/nagios-plugins/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "check_esxi_hardware";
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
