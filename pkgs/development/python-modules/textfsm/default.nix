{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, six
, future
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "textfsm";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fq2hphd89hns11nh0yifcp6brg6yy4n4hbvfk6avbjd7s40789a";
  };

  patches = [
    (fetchpatch {
      # remove pytest-runner dependency
      url = "https://github.com/google/textfsm/commit/212db75fea4a79aca0f8f85a78954ffbc5667096.patch";
      sha256 = "0n6qh3sz9wy5gdpq9jjxx8firis48ypr20yacs5bqri59sziwjp0";
    })
  ];

  propagatedBuildInputs = [ six future ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python module for parsing semi-structured text into python tables";
    homepage = "https://github.com/google/textfsm";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
