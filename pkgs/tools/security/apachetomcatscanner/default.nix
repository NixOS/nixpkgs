{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "apachetomcatscanner";
  version = "3.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "ApacheTomcatScanner";
    rev = "refs/tags/${version}";
    hash = "sha256-ChVVXUjm6y71iRs64Kv63oiOG1GSqmx6J0YiGtEI0ao=";
  };

  # Posted a PR for discussion upstream that can be followed:
  # https://github.com/p0dalirius/ApacheTomcatScanner/pull/32
  postPatch = ''
    sed -i '/apachetomcatscanner=apachetomcatscanner\.__main__:main/d' setup.py
  '';

  propagatedBuildInputs = with python3.pkgs; [
    requests
    sectools
    xlsxwriter
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [
    "apachetomcatscanner"
  ];

  meta = with lib; {
    description = "Tool to scan for Apache Tomcat server vulnerabilities";
    homepage = "https://github.com/p0dalirius/ApacheTomcatScanner";
    changelog = "https://github.com/p0dalirius/ApacheTomcatScanner/releases/tag/${version}";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
