{
  lib,
  fetchFromGitHub,
  beets,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "beets-copyartifacts";
  version = "0.1.5";

  src = fetchFromGitHub {
    repo = "beets-copyartifacts";
    owner = "adammillerio";
    rev = "v${version}";
    sha256 = "sha256-UTZh7T6Z288PjxFgyFxHnPt0xpAH3cnr8/jIrlJhtyU=";
  };

  postPatch = ''
    sed -i -e '/install_requires/,/\]/{/beets/d}' setup.py
    sed -i -e '/namespace_packages/d' setup.py
    printf 'from pkgutil import extend_path\n__path__ = extend_path(__path__, __name__)\n' >beetsplug/__init__.py

    # beets v2.1.0 compat
    # <https://github.com/beetbox/beets/commit/0e87389994a9969fa0930ffaa607609d02e286a8>
    sed -i -e 's/util\.py3_path/os.fsdecode/g' tests/_common.py
  '';

  pytestFlagsArray = [ "-r fEs" ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    beets
  ];
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "Beets plugin to move non-music files during the import process";
    homepage = "https://github.com/adammillerio/beets-copyartifacts";
    license = lib.licenses.mit;
    inherit (beets.meta) platforms;
  };
}
