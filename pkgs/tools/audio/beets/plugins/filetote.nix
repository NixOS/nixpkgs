{ lib
, fetchFromGitHub
, beets
, poetry-core
, python3Packages
, pytestCheckHook
}:

python3Packages.buildPythonApplication rec {
  pname = "beets-filetote";
  version = "0.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gtronset";
    repo = "beets-filetote";
    rev = "v${version}";
    hash = "sha256-ve6druyiu4WJJI1RKc20AMHPARD0h84myg8CM9paZeM=";
  };

  postPatch = ''
    sed -i -e '/audible/d' tests/helper.py
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  pytestFlagsArray = [
    "-r fEs"
  ];

  disabledTests = [
    "test_audible_m4b_files.py"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    beets
    toml
  ];

  pythonImportsCheck = [
    "beetsplug.filetote"
    "beetsplug.filetote_dataclasses"
  ];

  meta = with lib; {
    description = "Beets plugin to move non-music files during the import process";
    homepage = "https://github.com/gtronset/beets-filetote";
    changelog = "https://github.com/gtronset/beets-filetote/blob/${src.rev}/CHANGELOG.md";
    maintainers = with maintainers; [ dansbandit ];
    license = licenses.mit;
    inherit (beets.meta) platforms;
  };
}
