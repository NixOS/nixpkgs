{
  lib,
  beets,
  fetchFromGitHub,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "beets-copyartifacts";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "beets-copyartifacts";
    owner = "adammillerio";
    tag = "v${version}";
    hash = "sha256-UTZh7T6Z288PjxFgyFxHnPt0xpAH3cnr8/jIrlJhtyU=";
  };

  postPatch = ''
    sed -i -e '/namespace_packages/d' setup.py
    printf 'from pkgutil import extend_path\n__path__ = extend_path(__path__, __name__)\n' >beetsplug/__init__.py

    # beets v2.1.0 compat
    # <https://github.com/beetbox/beets/commit/0e87389994a9969fa0930ffaa607609d02e286a8>
    sed -i -e 's/util\.py3_path/os.fsdecode/g' tests/_common.py
  '';

  nativeBuildInputs = [
    beets
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    six
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pytestFlags = [
    # This is the same as:
    #   -r fEs
    "-rfEs"
  ];

  meta = {
    description = "Beets plugin to move non-music files during the import process";
    homepage = "https://github.com/adammillerio/beets-copyartifacts";
    changelog = "https://github.com/adammillerio/beets-copyartifacts/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    inherit (beets.meta) platforms;
    # Isn't compatible with beets >= 2.3
    broken = true;
  };
}
