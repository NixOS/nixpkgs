{ lib, python3, fetchFromGitHub }:

with python3.pkgs;

let lark-parser080 = lark-parser.overrideAttrs (old: rec {
      version = "0.8.0";
      src = fetchFromGitHub {
        owner = "lark-parser";
        repo = "lark";
        rev = version;
        sha256 = "su7kToZ05OESwRCMPG6Z+XlFUvbEb3d8DgsTEcPJMg4=";
      };
    });

in buildPythonApplication rec {
  pname = "gdtoolkit";
  version = "3.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3+zr1JcCt8HPwDG0j+ttnzGOhvUmaz+qzbE2wGyT86M=";
  };

  propagatedBuildInputs = [ lark-parser080 docopt pyyaml setuptools ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Scony/godot-gdscript-toolkit";
    description = "Independent set of GDScript tools - parser, linter and formatter";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.critbase ];
  };
}
