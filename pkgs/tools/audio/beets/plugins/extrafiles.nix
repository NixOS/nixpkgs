{ stdenv, fetchFromGitHub, beets, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "beets-extrafiles";
  version = "0.0.7";

  src = fetchFromGitHub {
    repo = "beets-extrafiles";
    owner = "Holzhaus";
    rev = "v${version}";
    sha256 = "0ah7mgax9zrhvvd5scf2z0v0bhd6xmmv5sdb6av840ixpl6vlvm6";
  };

  postPatch = ''
    sed -i -e '/install_requires/,/\]/{/beets/d}' setup.py
    sed -i -e '/namespace_packages/d' setup.py
  '';

  nativeBuildInputs = [ beets ];

  preCheck = ''
    HOME=$TEMPDIR
  '';

  meta = {
    homepage = "https://github.com/Holzhaus/beets-extrafiles";
    description = "A plugin for beets that copies additional files and directories during the import process";
    license = lib.licenses.mit;
  };
}
