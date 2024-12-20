{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "check-esxi-hardware";
  version = "20241129";
  format = "other";

  src = fetchFromGitHub {
    owner = "Napsty";
    repo = "check_esxi_hardware";
    tag = version;
    hash = "sha256-XCb70ttZ3sbva7/O+meliIn8vF7dilvRwEP6jZ8PanY=";
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
    homepage = "https://github.com/Napsty/check_esxi_hardware";
    changelog = "https://github.com/Napsty/check_esxi_hardware/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "check_esxi_hardware";
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
