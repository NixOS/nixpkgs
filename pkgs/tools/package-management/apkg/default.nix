{ lib, fetchFromGitLab, python3Packages
, gitMinimal, rpm, dpkg, fakeroot
}:

python3Packages.buildPythonApplication rec {
  pname = "apkg";
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.nic.cz";
    owner = "packaging";
    repo = pname;
    rev = "v${version}";
    sha256 = "duZz2Kwjgek5pMJTDH8gMZAZ13uFwaIYT5E1brW7I7U=";
  };

  propagatedBuildInputs = with python3Packages; [
    # copy&pasted requirements.txt (almost exactly)
    beautifulsoup4   # upstream version detection
    blessings        # terminal colors
    build            # apkg distribution
    cached-property  # @cached_property for python <= 3.7
    click            # nice CLI framework
    distro           # current distro detection
    jinja2           # templating
    packaging        # version parsing
    requests         # HTTP for humans™
    setuptools       # required by minver
    toml             # config files
  ];

  makeWrapperArgs = [ # deps for `srcpkg` operation for other distros; could be optional
    "--prefix" "PATH" ":" (lib.makeBinPath [ gitMinimal rpm dpkg fakeroot ])
  ];

  checkInputs = with python3Packages; [ pytest ];
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
  };
}
