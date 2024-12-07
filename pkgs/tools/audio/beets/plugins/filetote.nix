{
  lib,
  python3Packages,
  fetchFromGitHub,
  beets,
}:

python3Packages.buildPythonApplication rec {
  pname = "beets-filetote";
  version = "0.4.9";
  pyproject = true;

  build-system = with python3Packages; [ poetry-core ];

  src = fetchFromGitHub {
    owner = "gtronset";
    repo = "beets-filetote";
    rev = "v${version}";
    hash = "sha256-pZ6c2XQMSiiPHyZMLSiSE+LXeCfi3HEWtsTK5DP9YZE=";
  };

  postPatch = ''
    sed -i -e '/audible/d' tests/helper.py
  '';

  nativeBuildInputs = with python3Packages; [ poetry-core ];

  pytestFlagsArray = [ "-r fEs" ];

  disabledTests = [ "test_audible_m4b_files.py" ];

  nativeCheckInputs = with python3Packages; [
    beets
    pytestCheckHook
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
