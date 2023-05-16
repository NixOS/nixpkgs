{ lib, fetchFromGitLab, python3Packages
, gitMinimal, rpm, dpkg, fakeroot
}:

python3Packages.buildPythonApplication rec {
  pname = "apkg";
<<<<<<< HEAD
  version = "0.4.1";
  format = "pyproject";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.nic.cz";
    owner = "packaging";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "x7UYkqkF1XJ3OMfQpIQ4+27KI0dLvL42Wms5xQTY/H4=";
  };

  propagatedBuildInputs = with python3Packages; [
    # copy&pasted requirements.txt (almost exactly)
    beautifulsoup4   # upstream version detection
    blessed          # terminal colors
    build            # apkg distribution
    cached-property  # for python <= 3.7; but pip complains even with 3.8
=======
    sha256 = "duZz2Kwjgek5pMJTDH8gMZAZ13uFwaIYT5E1brW7I7U=";
  };

  # TODO: solve this properly.  Detection won't work anymore.
  postPatch = ''
    patch <<-EOF
      --- a/setup.py
      +++ b/setup.py
      @@ -25,1 +25,1 @@
      -    version=version,
      +    version='${version}',
    EOF
  '';

  propagatedBuildInputs = with python3Packages; [
    # copy&pasted requirements.txt (almost exactly)
    beautifulsoup4   # upstream version detection
    blessings        # terminal colors
    build            # apkg distribution
    cached-property  # @cached_property for python <= 3.7
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    click            # nice CLI framework
    distro           # current distro detection
    jinja2           # templating
    packaging        # version parsing
    requests         # HTTP for humans™
<<<<<<< HEAD
    toml             # config files
  ];

  nativeBuildInputs = with python3Packages; [ hatchling ];

=======
    setuptools       # required by minver
    toml             # config files
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  makeWrapperArgs = [ # deps for `srcpkg` operation for other distros; could be optional
    "--prefix" "PATH" ":" (lib.makeBinPath [ gitMinimal rpm dpkg fakeroot ])
  ];

<<<<<<< HEAD
  nativeCheckInputs = with python3Packages; [ pytest dunamai ];
=======
  nativeCheckInputs = with python3Packages; [ pytest ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
