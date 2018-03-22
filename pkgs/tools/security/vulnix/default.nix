{ stdenv, pythonPackages, fetchurl, callPackage, nix }:

pythonPackages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "vulnix";
  version = "1.4.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "19kfqxlrigrgwn74x06m70ar2fhyhic5kfmdanjwjcbaxblha3l8";
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
