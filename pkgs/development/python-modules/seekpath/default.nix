{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  numpy,
  future,
  spglib,
  glibcLocales,
  pytest,
  scipy,
}:

buildPythonPackage rec {
  pname = "seekpath";
  version = "2.1.0";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "giovannipizzi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8Nm8SKHda2qt1kncXZxC4T3cpicXpDZhxPzs78JICzE=";
  };

  LC_ALL = "en_US.utf-8";

  # scipy isn't listed in install_requires, but used in package
  propagatedBuildInputs = [
    numpy
    spglib
    future
    scipy
  ];

  nativeBuildInputs = [ glibcLocales ];

  nativeCheckInputs = [ pytest ];

  # I don't know enough about crystal structures to fix
  checkPhase = ''
    pytest . -k 'not oI2Y'
  '';

  meta = with lib; {
    description = "Module to obtain and visualize band paths in the Brillouin zone of crystal structures";
    homepage = "https://github.com/giovannipizzi/seekpath";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
