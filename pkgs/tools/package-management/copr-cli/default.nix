{ fetchFromGitHub, python39Packages }:

let
  inherit (python39Packages) buildPythonApplication;
  common-src = fetchFromGitHub {
    owner = "fedora-copr";
    repo = "copr";
    rev = "copr-cli-1.95-1";
    sha256 = "0p6mrir6yhp9mi52dicd4j183bjvxlqdh03w57s7l22fcmrhsz26";
  };
  python-copr = buildPythonApplication {
    propagatedBuildInputs = with python39Packages;
      [ requests-toolbelt requests marshmallow six munch ];
    src = common-src;
    sourceRoot = "./python";
    name = "copr";
    version = "1.112";
  };
in buildPythonApplication rec {
  propagatedBuildInputs = with python39Packages;
    [ requests humanize jinja2 simplejson python-copr ];
  src = common-src;
  sourceRoot = "./cli";
  name = "copr-cli";
  version = "1.95-1";
  doCheck = false;
}
