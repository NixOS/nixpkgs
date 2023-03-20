{ lib
, python3
, fetchFromGitHub
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "txt2tags";
  version = "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "txt2tags";
    repo = "txt2tags";
    rev = "refs/tags/${version}";
    hash = "sha256-urLsA2oeQM0WcKNDgaxKJOgBPGohJT6Zq6y6bEYMTxk=";
  };

  postPatch = ''
    substituteInPlace test/lib.py \
      --replace 'TXT2TAGS = os.path.join(TEST_DIR, "..", "txt2tags.py")' \
                'TXT2TAGS = "${placeholder "out"}/bin/txt2tags"' \
      --replace "[PYTHON] + TXT2TAGS" "TXT2TAGS"
  '';

  checkPhase = ''
    ${python3.interpreter} test/run.py
  '';

  meta = {
    changelog = "https://github.com/txt2tags/txt2tags/blob/${src.rev}/CHANGELOG.md";
    description = "Convert between markup languages";
    homepage = "https://txt2tags.org/";
    license  = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dotlambda kovirobi ];
  };
}
