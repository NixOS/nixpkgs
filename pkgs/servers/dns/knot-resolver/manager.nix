{ lib, fetchFromGitLab, python3 }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "knot-resolver-manager";
  version = "git-${src.rev}";

  src = fetchFromGitLab {
    domain = "gitlab.nic.cz";
    owner = "knot";
    repo = pname;
    rev = "905d4d26";
    hash = "sha256-QP8OrHj8TqVsKGDzorH7H+WetznpNY6B1U4Ce0VuZfc=";
  };

  propagatedBuildInputs = [ #TODO: review?
    jinja2
    pygobject3
    pyyaml
    aiohttp
    click
    pydbus
    requests
  ];

  checkInputs = [ supervisor pytest/*?*/ ];

  meta = with lib; { #FIXME
    maintainers = [ maintainers.vcunat /* upstream developer */ ];
  };
}
