{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ioccheck";
  version = "unstable-2021-09-29";
  format = "pyproject";

  disabled = python3.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ranguli";
    repo = pname;
    rev = "db02d921e2519b77523a200ca2d78417802463db";
    sha256 = "0lgqypcd5lzb2yqd5lr02pba24m26ghly4immxgz13svi8f6vzm9";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postPatch = ''
    # Can be removed with the next release
    substituteInPlace pyproject.toml \
      --replace '"hurry.filesize" = "^0.9"' ""
  '';

  pythonImportsCheck = [ "ioccheck" ];

  meta = with lib; {
    description = "Tool for researching IOCs";
    homepage = "https://github.com/ranguli/ioccheck";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
