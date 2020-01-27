{ lib, buildPythonPackage, fetchFromGitHub, python, six }:

buildPythonPackage rec {
  pname = "spavro";
  version = "1.1.22";
  
  src = fetchFromGitHub {
    owner = "pluralsight";
    repo = "spavro";
    # version 1.1.22 is not tagged on GitHub
    rev = "6a6c32d53e3b882964fbcbd9b4e3bfd071567be0";
    sha256 = "0y1gnh282j9phq0rmj9zrr19wzgdwn5n5svqlpc8icx8z3slf7g0";
  };
  
  propagatedBuildInputs = [ six ];
  
  # test_ipc.py:test_server_with_path depends on accessing an external server
  patchPhase = ''
    substituteInPlace test/test_ipc.py --replace \
    "def test_server_with_path(self):" \
    "@unittest.skip('depends on accessing an external server')
      def test_server_with_path(self):"
  '';
  
  checkPhase = ''
    ${python.interpreter} -m unittest discover -s test 
  '';
  
  meta = with lib; {
    description = "(SP)eedier AVRO implementation using Cython";
    homepage = "http://github.com/pluralsight/spavro";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
