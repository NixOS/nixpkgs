{ lib, libunwind, lz4, fetchFromGitHub, python3Packages }:

with python3Packages; buildPythonApplication rec {
  pname = "memray";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EiAwxV6jtb/oG+aaWLnF96h1ElyTI8HXt/4wIN3Y10M=";
  };

  doCheck = false;

  buildInputs = [ cython lz4 libunwind ];
  propagatedBuildInputs = [ rich jinja2 ];

  meta = with lib; {
    description = "Memray is a memory profiler for Python";
    license = licenses.asl20;
    homepage = "https://github.com/bloomberg/memray";
    maintainers = with maintainers; [ rski ];
  };
}
