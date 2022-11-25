{ lib
, python3
, fetchFromGitHub
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "txt2tags";
  version = "unstable-2022-10-17";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "txt2tags";
    repo = "txt2tags";
    rev = "114ab24ea9111060df136bfc1c8b1a35a59fe0f2";
    hash = "sha256-h2OtlUMzEHKyJ9AIO1Uo9Lx7jMYZNMtC6U+usBu7gNU=";
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
