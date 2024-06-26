{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

let
  bName = "check_esxi_hardware";

in
python3Packages.buildPythonApplication rec {
  pname = lib.replaceStrings [ "_" ] [ "-" ] bName;
  version = "20200710";
  format = "other";

  src = fetchFromGitHub {
    owner = "Napsty";
    repo = bName;
    rev = version;
    sha256 = "EC6np/01S+5SA2H9z5psJ9Pq/YoEyGdHL9wHUKKsNas=";
  };

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -Dm755 ${bName}.py $out/bin/${bName}
    install -Dm644 -t $out/share/doc/${pname} README.md

    runHook postInstall
  '';

  propagatedBuildInputs = with python3Packages; [
    pywbem
    requests
    setuptools
  ];

  meta = with lib; {
    homepage = "https://www.claudiokuenzler.com/nagios-plugins/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
