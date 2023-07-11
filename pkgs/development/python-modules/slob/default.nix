{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pyicu
, python
}:

buildPythonPackage {
  pname = "slob";
  version = "unstable-2020-06-26";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "itkach";
    repo = "slob";
    rev = "018588b59999c5c0eb42d6517fdb84036f3880cb";
    sha256 = "01195hphjnlcvgykw143rf06s6y955sjc1r825a58vhjx7hj54zh";
  };

  propagatedBuildInputs = [ pyicu ];

  checkPhase = ''
    ${python.interpreter} -m unittest slob
  '';

  pythonImportsCheck = [ "slob" ];

  meta = with lib; {
    homepage = "https://github.com/itkach/slob/";
    description = "Reference implementation of the slob (sorted list of blobs) format";
    license = licenses.gpl3Only;
  };
}
