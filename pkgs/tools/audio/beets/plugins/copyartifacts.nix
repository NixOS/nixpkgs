{ lib, fetchFromGitHub, beets, python3Packages }:

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
  '';

  pytestFlagsArray = [ "-r fEs" ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    beets
    six
  ];

  meta = {
    description = "Beets plugin to move non-music files during the import process";
    homepage = "https://github.com/adammillerio/beets-copyartifacts";
    license = lib.licenses.mit;
    inherit (beets.meta) platforms;
  };
}
