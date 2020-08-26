{ stdenv, fetchFromGitHub, beets, pythonPackages, glibcLocales }:

pythonPackages.buildPythonApplication {
  name = "beets-copyartifacts";

  src = fetchFromGitHub {
    repo = "beets-copyartifacts";
    owner = "sbarakat";
    rev = "d0bb75c8fc8fe125e8191d73de7ade6212aec0fd";
    sha256 = "19b4lqq1p45n348ssmql60jylw2fw7vfj9j22nly5qj5qx51j3g5";
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
    license = stdenv.lib.licenses.mit;
  };
}
