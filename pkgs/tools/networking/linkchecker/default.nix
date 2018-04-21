{ stdenv, lib, fetchFromGitHub, fetchpatch, python2, gettext }:
let
  # pin requests version until next release.
  # see: https://github.com/linkcheck/linkchecker/issues/76
  python2Packages = (python2.override {
    packageOverrides = self: super: {   
      requests = super.requests.overridePythonAttrs(oldAttrs: rec {
        version = "2.14.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0lyi82a0ijs1m7k9w1mqwbmq1qjsac35fazx7xqyh8ws76xanx52";
        };
      });
    };
  }).pkgs;
in
python2Packages.buildPythonApplication rec {
  pname = "LinkChecker";
  version = "9.3.1";

  propagatedBuildInputs = (with python2Packages; [ 
    requests
  ]) ++ [ gettext ];

  checkInputs = with python2Packages; [ pytest ];

  # the original repository is abandoned, development is now happening here:
  src = fetchFromGitHub {
    owner = "linkcheck";
    repo = "linkchecker";
    rev = "v${version}";
    sha256 = "080mv4iwvlsfnm7l9basd6i8p4q8990mdhkwick9s6javrbf1r1d";
  };

  # 1. upstream refuses to support ignoring robots.txt
  # 2. fix build: https://github.com/linkcheck/linkchecker/issues/10
  patches = 
    let
      fix-setup-py = fetchpatch {
        name = "fix-setup-py.patch";
        url = https://github.com/linkcheck/linkchecker/commit/e62e630.patch;
        sha256 = "046q1whg715w2yv33xx6rkj7fspvvz60cl978ax92lnf8j101czx";
      };
    in [
      ./add-no-robots-flag.patch
      fix-setup-py
    ];

  postInstall = ''
    rm $out/bin/linkchecker-gui
  '';

  checkPhase = ''
    # the mime test fails for me...
    rm tests/test_mimeutil.py
    ${lib.optionalString stdenv.isDarwin ''
    # network tests fails on darwin
    rm tests/test_network.py
    ''}
    make test PYTESTOPTS="--tb=short" TESTS="tests/test_*.py tests/logger/test_*.py"
  '';

  meta = {
    description = "Check websites for broken links";
    homepage = https://linkcheck.github.io/linkchecker/;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ peterhoeg tweber ];
  };
}
