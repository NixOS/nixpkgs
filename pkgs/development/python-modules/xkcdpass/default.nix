{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, installShellFiles
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xkcdpass";
  version = "1.19.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zEgC3tTQ6kwDovHPHRTvYndWVF79DpnAX454VDZiedE=";
  };

  patches = [
    (fetchpatch {
      name = "fix-non-deterministic-test.patch";
      url = "https://github.com/redacted/XKCD-password-generator/commit/72d174a82822af1934c94de1b66fd956230142f5.patch";
      hash = "sha256-GES40GHM0+Zx8bRceCy9/fOHJVlWZ7TCLfzhZczjfTE=";
    })
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xkcdpass"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/redacted/XKCD-password-generator/issues/138
    "test_entropy_printout_valid_input"
  ];

  postInstall = ''
    installManPage *.?
    install -Dm444 -t $out/share/doc/${pname} README*
  '';

  meta = with lib; {
    description = "Generate secure multiword passwords/passphrases, inspired by XKCD";
    homepage = "https://github.com/redacted/XKCD-password-generator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
