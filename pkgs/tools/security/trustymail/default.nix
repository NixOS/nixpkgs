{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trustymail";
  version = "0.8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cisagov";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hKiQWAOzUjmoCcEH9OTgkgU7s1V+Vv3+93OLkqDRDoU=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --cov" ""
  '';

  propagatedBuildInputs = with python3.pkgs; [
    dnspython
    docopt
    publicsuffixlist
    pydns
    pyspf
    requests
  ] ++ publicsuffixlist.optional-dependencies.update;

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "trustymail"
  ];

  meta = with lib; {
    description = "Tool to scan domains and return data based on trustworthy email best practices";
    homepage = "https://github.com/cisagov/trustymail";
    changelog = "https://github.com/cisagov/trustymail/releases/tag/v${version}";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
