{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, voluptuous, pytest }:

buildPythonPackage rec  {
  pname = "voluptuous-serialize";
  version = "2018-03-10";

  disabled = !isPy3k;

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "balloob";
    repo = pname;
    rev = "567f0d96f928cf6c30c9f1b8bdee729e651aac82";
    sha256 = "0b16f1bxlqyvi1hy8wmzp2k0rzqcycmdhs8zwsyx0swnvkgwnv50";
  };

  propagatedBuildInputs = [
    voluptuous
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/balloob/voluptuous-serialize;
    license = licenses.asl20;
    description = "Convert Voluptuous schemas to dictionaries so they can be serialized";
    maintainers = with maintainers; [ etu ];
  };
}
