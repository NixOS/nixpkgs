{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "sewer";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qnxg7s1AwU84/tw40q2tiY0VUErE5sN90ayhbQ0HDmk=";
  };

  propagatedBuildInputs = with python3Packages; [ pyopenssl requests tldextract ];

  meta = with lib; {
    homepage = "https://github.com/komuw/sewer";
    description = "ACME client";
    license = licenses.mit;
    maintainers = with maintainers; [ kevincox ];
  };
}
