{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, PyICU
, python
}:

buildPythonPackage rec {
  name = "slob";
  verison = "unstable-2016-11-03";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "itkach";
    repo = "slob";
    rev = "d1ed71e4778729ecdfc2fe27ed783689a220a6cd";
    sha256 = "1r510s4r124s121wwdm9qgap6zivlqqxrhxljz8nx0kv0cdyypi5";
  };

  propagatedBuildInputs = [ PyICU ];

  checkPhase = ''
    ${python.interpreter} -m unittest slob
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/itkach/slob/;
    description = "Reference implementation of the slob (sorted list of blobs) format";
    license = licenses.gpl3;
    maintainers = [ maintainers.rycee ];
  };

}
