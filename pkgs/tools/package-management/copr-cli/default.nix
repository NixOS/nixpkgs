{ fetchFromGitHub, python39Packages }:

let
  inherit (python39Packages) buildPythonApplication;
  common-src = fetchFromGitHub {
    owner = "fedora-copr";
    repo = "copr";
    rev = "copr-cli-1.95-1";
    sha256 = "1qhn1l4ikkf6z391q1n68m9c50h1wvxya4w25pnzryklqz9xfra4";
  };
  python-copr = buildPythonApplication {
    propagatedBuildInputs = with python39Packages;
      [ requests-toolbelt requests marshmallow six munch ];
    src = "${common-src}/python";
    name = "copr";
    version = "1.112";
  };
in buildPythonApplication rec {
  propagatedBuildInputs = with python39Packages;
    [ requests humanize jinja2 simplejson python-copr ];
  src = "${common-src}/cli";
  name = "copr-cli";
  version = "1.95-1";
  doCheck = false;
}
