{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "usbrip";
  version = "unstable-2021-07-02";

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "snovvcrash";
    repo = pname;
    rev = "0f3701607ba13212ebefb4bbd9e68ec0e22d76ac";
    sha256 = "1vws8ybhv7szpqvlbmv0hrkys2fhhaa5bj9dywv3q2y1xmljl0py";
  };

  propagatedBuildInputs = with python3.pkgs; [
    termcolor
    terminaltables
    tqdm
  ];

  postPatch = ''
    # Remove install helpers which we don't need
    substituteInPlace setup.py \
      --replace "parse_requirements('requirements.txt')," "[]," \
      --replace "resolve('wheel')" "" \
      --replace "'install': LocalInstallCommand," ""
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "usbrip" ];

  meta = with lib; {
    description = "Tool to track the history of USB events";
    homepage = "https://github.com/snovvcrash/usbrip";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
