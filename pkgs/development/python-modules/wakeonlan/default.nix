{ stdenv, fetchPypi, buildPythonPackage, setuptools_scm, pytest, mock }:

buildPythonPackage rec {
  pname = "wakeonlan";
  version = "1.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e6013a17004809e676c150689abd94bcc0f12a37ad3fbce1f6270968f95ffa9";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "setuptools-scm ~= 1.15.7" "setuptools-scm"
  '';

  checkInputs = [ pytest mock ];

  nativeBuildInputs = [ setuptools_scm ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "A small python module for wake on lan";
    homepage = https://github.com/remcohaszing/pywakeonlan;
    license = licenses.wtfpl;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
