{ lib, fetchFromGitHub, beets, pythonPackages, glibcLocales }:

pythonPackages.buildPythonApplication {
  pname = "beets-copyartifacts";
  version = "unstable-2020-02-15";

  src = fetchFromGitHub {
    repo = "beets-copyartifacts";
    owner = "adammillerio";
    rev = "85eefaebf893cb673fa98bfde48406ec99fd1e4b";
    sha256 = "sha256-bkT2BZZ2gdcacgvyrVe2vMrOMV8iMAm8Q5xyrZzyqU0=";
  };

  postPatch = ''
    sed -i -e '/install_requires/,/\]/{/beets/d}' setup.py
    sed -i -e '/namespace_packages/d' setup.py
    printf 'from pkgutil import extend_path\n__path__ = extend_path(__path__, __name__)\n' >beetsplug/__init__.py

    # Skip test which is already failing upstream.
    sed -i -e '1i import unittest' \
           -e 's/\(^ *\)# failing/\1@unittest.skip/' \
           tests/test_reimport.py
  '';

  nativeBuildInputs = [ beets pythonPackages.nose glibcLocales ];

  checkPhase = "LANG=en_US.UTF-8 nosetests";

  meta = {
    description = "Beets plugin to move non-music files during the import process";
    homepage = "https://github.com/sbarakat/beets-copyartifacts";
    license = lib.licenses.mit;
  };
}
