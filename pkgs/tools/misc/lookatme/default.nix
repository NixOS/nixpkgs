{ lib, python3, fetchFromGitHub }:

let
  py = python3.override {
    packageOverrides = self: super: {
      self = py;
      # use click 7
      click = self.callPackage ../../../development/python2-modules/click/default.nix { };
      # needs pyyaml 5
      pyyaml = super.pyyaml.overridePythonAttrs (oldAttrs: rec {
        name = "${oldAttrs.pname}-${version}";
        version = "5.4.1";
        src = fetchFromGitHub {
          owner = "yaml";
          repo = "pyyaml";
          rev = version;
          sha256 = "sha256-VUqnlOF/8zSOqh6JoEYOsfQ0P4g+eYqxyFTywgCS7gM=";
        };
        checkPhase = ''
          runHook preCheck
          PYTHONPATH="tests/lib3:$PYTHONPATH" ${self.python.interpreter} -m test_all
          runHook postCheck
        '';
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "lookatme";
  version = "2.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qIZMkgOm5jXmxTFLTqMBhpLBhfCL8xvUxxqpS6NjcVw=";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [
    click
    pyyaml
    pygments
    marshmallow
    mistune
    urwid
  ];

  meta = with lib; {
    description = "An interactive, terminal-based markdown presenter";
    homepage = "https://github.com/d0c-s4vage/lookatme";
    license = licenses.mit;
    maintainers = with maintainers; [ ameer ];
  };
}
