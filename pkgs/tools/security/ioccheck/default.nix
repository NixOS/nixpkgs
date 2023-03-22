{ lib
, fetchFromGitHub
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      emoji = super.emoji.overridePythonAttrs (oldAttrs: rec {
        version = "1.7.0";

        src = fetchFromGitHub {
          owner = "carpedm20";
          repo = "emoji";
          rev = "v${version}";
          sha256 = "sha256-vKQ51RP7uy57vP3dOnHZRSp/Wz+YDzeLUR8JnIELE/I=";
        };
      });

      # Support for later tweepy releases is missing
      # https://github.com/ranguli/ioccheck/issues/70
      tweepy = super.tweepy.overridePythonAttrs (oldAttrs: rec {
        version = "3.10.0";

        src = fetchFromGitHub {
          owner = "tweepy";
          repo = "tweepy";
          rev = "v${version}";
          sha256 = "0k4bdlwjna6f1k19jki4xqgckrinkkw8b9wihzymr1l04rwd05nw";
        };
        doCheck = false;
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "ioccheck";
  version = "unstable-2021-09-29";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ranguli";
    repo = pname;
    rev = "db02d921e2519b77523a200ca2d78417802463db";
    hash = "sha256-qf5tHIpbj/BfrzUST+EzohKh1hUg09KwF+vT0tj1+FE=";
  };

  nativeBuildInputs = with py.pkgs; [
    poetry-core
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
      --replace '"hurry.filesize" = "^0.9"' "" \
      --replace 'vt-py = ">=0.6.1,<0.8.0"' 'vt-py = ">=0.6.1"' \
      --replace 'backoff = "^1.10.0"' 'backoff = ">=1.10.0"' \
      --replace 'termcolor = "^1.1.0"' 'termcolor = "*"' \
      --replace 'tabulate = "^0.8.9"' 'tabulate = "*"'
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
