{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "amoco";
  version = "2.9.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bdcht";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3+1ssFyU7SKFJgDYBQY0kVjmTHOD71D2AjnH+4bfLXo=";
  };

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    blessed
    click
    crysp
    grandalf
    pyparsing
    tqdm
    traitlets
  ];

  passthru.optional-dependencies = {
    app = with python3.pkgs; [
      # ccrawl
      ipython
      prompt-toolkit
      pygments
      # pyside6
      z3-solver
    ];
  };

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  pythonRelaxDeps = [
    "grandalf"
    "crysp"
  ];

  pythonImportsCheck = [
    "amoco"
  ];

  disabledTests = [
    # AttributeError: 'str' object has no attribute '__dict__'
    "test_func"
  ];

  meta = with lib; {
    description = "Tool for analysing binaries";
    homepage = "https://github.com/bdcht/amoco";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
