{ lib, fetchFromGitHub, python }:

python.pkgs.buildPythonApplication rec {
  version = "1.4.2";
  pname = "brotab";

  src = fetchFromGitHub {
    owner = "balta2ar";
    repo = pname;
    rev = version;
    hash = "sha256-HKKjiW++FwjdorqquSCIdi1InE6KbMbFKZFYHBxzg8Q=";
  };

  propagatedBuildInputs = with python.pkgs; [
    requests
    flask
    psutil
    setuptools
  ];

  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace "Flask==2.0.2" "Flask>=2.0.2" \
      --replace "psutil==5.8.0" "psutil>=5.8.0" \
      --replace "requests==2.24.0" "requests>=2.24.0"
  '';

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/balta2ar/brotab";
    description = "Control your browser's tabs from the command line";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
