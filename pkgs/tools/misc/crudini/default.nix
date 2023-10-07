{ lib
, fetchFromGitHub
, fetchpatch
, python3Packages
, help2man
, installShellFiles
}:

python3Packages.buildPythonApplication rec {
  pname = "crudini";
  version = "0.9.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pixelb";
    repo = "crudini";
    rev = version;
    hash = "sha256-BU4u7uBsNyDOwWUjOIlBWcf1AeUXXZ+johAe+bjws1U=";
  };

  postPatch = ''
    patchShebangs crudini.py crudini-help tests/test.sh
  '';

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    help2man
    installShellFiles
    python3Packages.setuptools
    python3Packages.setuptools-scm
    python3Packages.wheel
  ];

  propagatedBuildInputs = with python3Packages; [ iniparse ];

  postInstall = ''
    # this just creates the man page
    make all

    install -Dm444 -t $out/share/doc/${pname} README.md EXAMPLES
    installManPage *.1
  '';

  checkPhase = ''
    runHook preCheck

    pushd tests >/dev/null
    ./test.sh
    popd >/dev/null

    runHook postCheck
  '';

  meta = with lib; {
    description = "A utility for manipulating ini files ";
    homepage = "https://www.pixelbeat.org/programs/crudini/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "crudini";
  };
}
