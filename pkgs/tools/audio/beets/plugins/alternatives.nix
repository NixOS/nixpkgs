{ lib, fetchFromGitHub, beets, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "beets-alternatives";
  version = "unstable-2021-02-01";

  src = fetchFromGitHub {
    repo = "beets-alternatives";
    owner = "geigerzaehler";
    rev = "288299e3aa9a1602717b04c28696fce5ce4259bf";
    sha256 = "sha256-Xl7AHr33hXQqQDuFbWuj8HrIugeipJFPmvNXpCkU/mI=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "addopts = --cov --cov-report=term --cov-report=html" ""
  '';

  nativeBuildInputs = [ beets ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    mock
  ];

  meta = with lib; {
    description = "Beets plugin to manage external files";
    homepage = "https://github.com/geigerzaehler/beets-alternatives";
    maintainers = with maintainers; [ aszlig lovesegfault ];
    license = licenses.mit;
  };
}
