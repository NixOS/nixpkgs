{ lib
, python3Packages
, fetchFromGitHub
, hiera-eyaml
, python3
}:
let
  py = python3.override {
    packageOverrides = self: super: {
      ruamel-yaml = super.ruamel-yaml.overridePythonAttrs(old: rec {
        pname = "ruamel.yaml";
        version = "0.17.10";
        src = python3Packages.fetchPypi {
          inherit pname version;
          sha256 = "EGvI1txqD/fJGWpHVwQyA29B1Va3eca05hgIX1fjnmc=";
        };
      });
    };
  };
in
py.pkgs.buildPythonPackage rec {
  pname = "yamlpath";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "wwkimball";
    repo = pname;
    rev = "v${version}";
    sha256 = "4lLKMMsjVWbnfiaOzdBePOtOwPN8nui3Ux6e55YdGoo=";
  };

  propagatedBuildInputs = with py.pkgs; [ ruamel-yaml ];
  checkInputs = with py.pkgs; [ hiera-eyaml mock pytest-console-scripts pytestCheckHook ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/wwkimball/yamlpath";
    description = "Command-line processors for YAML/JSON/Compatible data";
    longDescription = ''
      Command-line get/set/merge/validate/scan/convert/diff processors for YAML/JSON/Compatible data using powerful, intuitive, command-line friendly syntax
     '';
    license = licenses.isc;
    maintainers = with maintainers; [ Flakebi ];
  };
}
