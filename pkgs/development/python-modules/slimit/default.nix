{ lib, buildPythonPackage, fetchPypi, isPy3k, fetchpatch, python, ply }:

buildPythonPackage rec {
  pname = "slimit";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "f433dcef899f166b207b67d91d3f7344659cb33b8259818f084167244e17720b";
  };

  # Some patches from https://github.com/rspivak/slimit/pull/65
  patches = lib.optionals isPy3k [
    (fetchpatch {
      url = https://github.com/lelit/slimit/commit/a61e12d88cc123c4b7af2abef21d06fd182e561a.patch;
      sha256 = "0lbhvkgn4l8g9fwvb81rfwjx7hsaq2pid8a5gczdk1ba65wfvdq5";
    })
    (fetchpatch {
      url = https://github.com/lelit/slimit/commit/e8331659fb89e8a4613c5e4e338c877fead9c551.patch;
      sha256 = "1hv4ysn09c9bfd5bxhhrp51hsi81hdidmx0y7zcrjjiich9ayrni";
    })
  ];

  propagatedBuildInputs = [ ply ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s src/slimit
  '';

  meta = with lib; {
    description = "JavaScript minifier";
    homepage = http://slimit.readthedocs.org/;
    license = licenses.mit;
  };
}
