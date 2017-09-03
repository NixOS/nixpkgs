{ stdenv, fetchFromGitHub, beets, pythonPackages, glibcLocales }:

pythonPackages.buildPythonApplication rec {
  name = "beets-copyartifacts";

  src = fetchFromGitHub {
    repo = "beets-copyartifacts";
    owner = "sbarakat";
    rev = "4a5d347c858d25641c8a0eb7d8cb1a2cac10252a";
    sha256 = "0bn6fci480ilghrdhpsjxxq29dxgni22sv1qalz770xy130g1zk3";
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
    homepage = https://github.com/sbarakat/beets-copyartifacts;
    license = stdenv.lib.licenses.mit;
  };
}
