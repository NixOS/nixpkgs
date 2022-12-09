{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, cerberus
, django
, djangorestframework
, marshmallow
, pyschemes
, wtforms
, email-validator
}:

buildPythonPackage rec {
  pname = "vaa";
  version = "0.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "life4";
    repo = pname;
    rev = "refs/tags/v.${version}";
    hash = "sha256-24GTTJSZ55ejyHoWP1/S3DLTKvOolAJr9UhWoOm84CU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "requires = [\"flit\"]" "requires = [\"flit_core\"]" \
      --replace "build-backend = \"flit.buildapi\"" "build-backend = \"flit_core.buildapi\""
  '';

  nativeBuildInputs = [
    flit-core
  ];

  checkInputs = [
    pytestCheckHook
    cerberus
    django
    djangorestframework
    marshmallow
    pyschemes
    wtforms
    email-validator
  ];

  pythonImportsCheck = [ "vaa" ];

  meta = with lib; {
    description = "VAlidators Adapter makes validation by any existing validator with the same interface";
    homepage = "https://github.com/life4/vaa";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
