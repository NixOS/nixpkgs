{ lib, fetchFromGitLab, python3Packages
, gitMinimal, rpm, dpkg, fakeroot
}:

python3Packages.buildPythonApplication rec {
  pname = "apkg";
  version = "0.4.1";
  format = "pyproject";

  src = fetchFromGitLab {
    domain = "gitlab.nic.cz";
    owner = "packaging";
    repo = pname;
    rev = "v${version}";
    sha256 = "x7UYkqkF1XJ3OMfQpIQ4+27KI0dLvL42Wms5xQTY/H4=";
  };

  propagatedBuildInputs = with python3Packages; [
    # copy&pasted requirements.txt (almost exactly)
    beautifulsoup4   # upstream version detection
    blessed          # terminal colors
    build            # apkg distribution
    cached-property  # for python <= 3.7; but pip complains even with 3.8
    click            # nice CLI framework
    distro           # current distro detection
    jinja2           # templating
    packaging        # version parsing
    requests         # HTTP for humans™
    toml             # config files
  ];

  nativeBuildInputs = with python3Packages; [ hatchling ];

  makeWrapperArgs = [ # deps for `srcpkg` operation for other distros; could be optional
    "--prefix" "PATH" ":" (lib.makeBinPath [ gitMinimal rpm dpkg fakeroot ])
  ];

  nativeCheckInputs = with python3Packages; [ pytest dunamai ];
  checkPhase = ''
    runHook preCheck
    py.test # inspiration: .gitlab-ci.yml
    runHook postCheck
  '';

  meta = with lib; {
    description = "Upstream packaging automation tool";
    homepage = "https://pkg.labs.nic.cz/pages/apkg";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.vcunat /* close to upstream */ ];
    mainProgram = "apkg";
  };
}
