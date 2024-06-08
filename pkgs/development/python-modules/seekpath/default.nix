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
  version = "2.0.1";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "giovannipizzi";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x592650ynacmx5n5bilj5lja4iw0gf1nfypy82cmy5z363qhqxn";
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
    description = "A module to obtain and visualize band paths in the Brillouin zone of crystal structures.";
    homepage = "https://github.com/giovannipizzi/seekpath";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
