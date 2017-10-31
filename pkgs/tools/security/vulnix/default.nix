{ stdenv, pythonPackages, fetchurl, callPackage, nix }:

pythonPackages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "vulnix";
  version = "1.3.4";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1js1i86pgkkqc9yzp1rck7rmaz79klv4048r9z7v56fam0a6sg05";
  };

  buildInputs = with pythonPackages; [ flake8 pytest pytestcov ];

  propagatedBuildInputs = [
    nix
  ] ++ (with pythonPackages; [
    click
    colorama
    lxml
    pyyaml
    requests
    zodb
  ]);

  postPatch = ''
    sed -i -e 's/==\([^=]\+\)/>=\1/g' setup.py
  '';

  checkPhase = "py.test";

  meta = with stdenv.lib; {
    description = "NixOS vulnerability scanner";
    homepage = https://github.com/flyingcircusio/vulnix;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ckauhaus plumps ];
  };
}
