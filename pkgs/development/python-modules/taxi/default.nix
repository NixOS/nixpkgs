{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  appdirs,
  click,
  flit-core,
  pytestCheckHook,
  freezegun,
}:

buildPythonPackage rec {
  pname = "taxi";
<<<<<<< HEAD
  version = "6.3.2";
=======
  version = "6.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sephii";
    repo = "taxi";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-zhBjULAPd1rGvTMdy7TJ3XoDDMGnoL6fyZFTVIHDvDI=";
=======
    hash = "sha256-QB88RpgzrQy7DGeRdMHC2SV5Esp/r5LZtlaY5C8vJxw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ flit-core ];

  dependencies = [
    appdirs
    click
  ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "taxi" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/sephii/taxi/";
    description = "Timesheeting made easy";
    mainProgram = "taxi";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ jocelynthode ];
=======
  # Broken by the update of `click` from version 8.1.8 -> 8.2.1 in
  # https://github.com/NixOS/nixpkgs/pull/448189.
  disabledTests = [
    "test_ignore_date_error_week_day"
    "test_ignore_date_error_previous_day"
  ];

  meta = with lib; {
    homepage = "https://github.com/sephii/taxi/";
    description = "Timesheeting made easy";
    mainProgram = "taxi";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ jocelynthode ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
