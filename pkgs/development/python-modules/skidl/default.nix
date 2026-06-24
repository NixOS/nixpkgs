{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  kinparse,
  pyspice,
  graphviz,
  python,
  sexpdata,
  simp-sexp,
}:
buildPythonPackage rec {
  pname = "skidl";
  version = "2.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "devbisme";
    repo = "skidl";
    tag = "v${version}";
    sha256 = "sha256-7rauFhaLXyZ5SGtEF7qoAbrj/VgP4qpl+BWUeERefb4=";
  };

  propagatedBuildInputs = [
    kinparse
    pyspice
    graphviz
    sexpdata
    simp-sexp
  ];

  # Checks require availability of the kicad symbol libraries.
  doCheck = false;

  # Avoid import-time log files in $out.
  dontUsePythonImportsCheck = true;
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export XDG_DATA_HOME="$TMPDIR/skidl-data"
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
    cd "$TMPDIR"
    ${python.interpreter} -c "import skidl"

    runHook postInstallCheck
  '';

  meta = {
    description = "SKiDL is a module that extends Python with the ability to design electronic circuits";
    mainProgram = "netlist_to_skidl";
    homepage = "https://devbisme.github.io/skidl/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthuszagh ];
  };
}
