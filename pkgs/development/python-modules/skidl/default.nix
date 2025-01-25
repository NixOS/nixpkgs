{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  kinparse,
  pyspice,
  graphviz,
  sexpdata,
  nix-update-script,
  pkgs,
}:

buildPythonPackage rec {
  pname = "skidl";
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "devbisme";
    repo = pname;
    tag = version;
    hash = "sha256-EzKtXdQFB6kjaIuCYAsyFPlwmkefb5RJcnpFYCVHHb8=";
  };

  propagatedBuildInputs = [
    pyspice
    graphviz
    kinparse
    sexpdata
  ];

  # set path to KiCad symbols
  KICAD8_SYMBOL_DIR = "${lib.getBin pkgs.kicad.passthru.libraries.symbols}/share/kicad/symbols";
  makeWrapperArgs = [
    "--set KICAD8_SYMBOL_DIR ${lib.getBin pkgs.kicad.passthru.libraries.symbols}/share/kicad/symbols"
  ];

  doInstallCheck = true;
  pythonImportsCheck = [ "skidl" ];
  # check needs writes logfiles to the current working directory
  checkPhase = ''
    runHook preCheck

    cd $(mktemp -d);
    # export KICAD8_SYMBOL_DIR="${lib.getBin pkgs.kicad.passthru.libraries.symbols}/share/kicad/symbols"
    $out/bin/${meta.mainProgram} --version | grep -q "skidl ${version}"

    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Module that extends Python with the ability to design electronic circuits";
    mainProgram = "netlist_to_skidl";
    homepage = "https://devbisme.github.io/skidl/";
    changelog = "https://github.com/devbisme/skidl/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
