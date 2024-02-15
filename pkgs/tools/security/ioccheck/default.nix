{ lib
, fetchFromGitHub
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      emoji = super.emoji.overridePythonAttrs rec {
        version = "1.7.0";

        src = fetchFromGitHub {
          owner = "carpedm20";
          repo = "emoji";
          rev = "v${version}";
          hash = "sha256-vKQ51RP7uy57vP3dOnHZRSp/Wz+YDzeLUR8JnIELE/I=";
        };
      };

      # Support for later tweepy releases is missing
      # https://github.com/ranguli/ioccheck/issues/70
      tweepy = super.tweepy.overridePythonAttrs rec {
        version = "3.10.0";

        src = fetchFromGitHub {
          owner = "tweepy";
          repo = "tweepy";
          rev = "v${version}";
          hash = "sha256-3BbQeCaAhlz9h5GnhficNubJHu4kTpnCDM4oKzlti0w=";
        };
        doCheck = false;
      };
    };
  };
in py.pkgs.buildPythonApplication rec {
  pname = "ioccheck";
  version = "unstable-2021-09-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ranguli";
    repo = "ioccheck";
    rev = "db02d921e2519b77523a200ca2d78417802463db";
    hash = "sha256-qf5tHIpbj/BfrzUST+EzohKh1hUg09KwF+vT0tj1+FE=";
  };

  nativeBuildInputs = with py.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "backoff"
    "pyfiglet"
    "tabulate"
    "termcolor"
    "vt-py"
  ];

  propagatedBuildInputs = with py.pkgs; [
    backoff
    click
    emoji
    jinja2
    pyfiglet
    ratelimit
    requests
    shodan
    tabulate
    termcolor
    tweepy
    vt-py
  ];

  nativeCheckInputs = with py.pkgs; [
    pytestCheckHook
  ];

  postPatch = ''
    # Can be removed with the next release
    substituteInPlace pyproject.toml \
      --replace '"hurry.filesize" = "^0.9"' ""
  '';

  pythonImportsCheck = [
    "ioccheck"
  ];

  meta = with lib; {
    description = "Tool for researching IOCs";
    homepage = "https://github.com/ranguli/ioccheck";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
