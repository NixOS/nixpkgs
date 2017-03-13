{ buildPythonPackage,
  callPackage,
  click,
  colorama,
  fetchurl,
  flake8,
  lxml,
  nix,
  python,
  pytest,
  pytestcov,
  stdenv,
  }:

let
  external = callPackage ./requirements.nix { inherit buildPythonPackage fetchurl stdenv; };
in

buildPythonPackage rec{
  name = "${pname}-${version}";
  pname = "vulnix";
  version = "1.2.2";

  src = fetchurl {
    url = "https://pypi.python.org/packages/90/c9/ebef9243334a99edb8598061efae0f00d7a199b01bea574a84e31e06236d/vulnix-${version}.tar.gz";
    sha256 = "1ia9plziwach0bxnlcd33q30kcsf8sv0nf2jc78gsmrqnxjabr12";
  };

  buildInputs = [
    flake8
    pytest
    pytestcov
  ];

  propagatedBuildInputs = [
    click
    colorama
    nix
    external.lxml
    external.PyYAML
    external.requests
    external.ZODB
  ];

  checkPhase = ''
    export PYTHONPATH=src:$PYTHONPATH
    py.test
  '';

  meta = with stdenv.lib; {
    description = "NixOS vulnerability scanner";
    homepage = https://github.com/flyingcircusio/vulnix;
    license = licenses.bsd2;
    maintainers = with maintainers; [ plumps ];
  };
}