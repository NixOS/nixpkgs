{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trustymail";
  version = "0.8.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cisagov";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-aFXz78Gviki0yIcnn2EgR3mHmt0wMoY5u6RoT6zQc1Y=";
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
