{
  lib,
  fetchFromGitHub,
  python311,
}:

let
  python = python311.override {
    packageOverrides = self: super: {
      pyparsing = super.pyparsing.overridePythonAttrs rec {
        version = "2.4.7";
        src = fetchFromGitHub {
          owner = "pyparsing";
          repo = "pyparsing";
          rev = "pyparsing_${version}";
          sha256 = "14pfy80q2flgzjcx8jkracvnxxnr59kjzp3kdm5nh232gk1v6g6h";
        };
        nativeBuildInputs = [ super.setuptools ];
      };
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "gixy";
  version = "0.1.20";
  pyproject = true;

  # fetching from GitHub because the PyPi source is missing the tests
  src = fetchFromGitHub {
    owner = "yandex";
    repo = "gixy";
    rev = "v${version}";
    sha256 = "14arz3fjidb8z37m08xcpih1391varj8s0v3gri79z3qb4zq5k6b";
  };

  build-system = [ python.pkgs.setuptools ];

  dependencies = with python.pkgs; [
    cached-property
    configargparse
    pyparsing
    jinja2
    six
  ];

  nativeCheckInputs = [ python.pkgs.nose3 ];

  pythonRemoveDeps = [ "argparse" ];

  meta = {
    description = "Nginx configuration static analyzer";
    mainProgram = "gixy";
    longDescription = ''
      Gixy is a tool to analyze Nginx configuration.
      The main goal of Gixy is to prevent security misconfiguration and automate flaw detection.
    '';
    homepage = "https://github.com/yandex/gixy";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.willibutz ];
    platforms = lib.platforms.unix;
  };
}
