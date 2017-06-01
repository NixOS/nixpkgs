{ stdenv, pythonPackages, fetchurl, callPackage, nix, }:

let
  external = callPackage ./requirements.nix {
    inherit pythonPackages;
  };
in pythonPackages.buildPythonApplication rec{
  name = "${pname}-${version}";
  pname = "vulnix";
  version = "1.2.2";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1ia9plziwach0bxnlcd33q30kcsf8sv0nf2jc78gsmrqnxjabr12";
  };

  buildInputs = with pythonPackages; [ flake8 pytest pytestcov ];

  postPatch = ''
    sed -i -e 's/==\([^=]\+\)/>=\1/g' setup.py
  '';

  propagatedBuildInputs = [
    nix
  ] ++ (with pythonPackages; [
    click
    colorama
    lxml
    pyyaml
    requests
    external.zodb
  ]);

  checkPhase = "py.test";

  meta = with stdenv.lib; {
    description = "NixOS vulnerability scanner";
    homepage = https://github.com/flyingcircusio/vulnix;
    license = licenses.bsd2;
    maintainers = with maintainers; [ plumps ];
  };
}
