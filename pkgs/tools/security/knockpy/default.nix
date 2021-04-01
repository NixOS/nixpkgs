{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "knockpy";
  version = "5.0.0";
  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "guelfoweb";
    repo = "knock";
    rev = version;
    sha256 = "1h7sibdxx8y53xm1wydyng418n4j6baiys257msq03cs04jlm7h9";
  };

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    colorama
    requests
  ];

  postPatch = ''
    # https://github.com/guelfoweb/knock/pull/95
    substituteInPlace setup.py \
      --replace "bs4" "beautifulsoup4"
  '';

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "knockpy" ];

  meta = with lib; {
    description = "Tool to scan subdomains";
    homepage = "https://github.com/guelfoweb/knock";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
