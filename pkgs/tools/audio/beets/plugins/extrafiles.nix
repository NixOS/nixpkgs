{ lib, fetchFromGitHub, beets, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "beets-extrafiles";
  version = "unstable-2020-12-13";

  src = fetchFromGitHub {
    repo = "beets-extrafiles";
    owner = "Holzhaus";
    rev = "a1d6ef9a9682b6bf7af9483541e56a3ff12247b8";
    sha256 = "sha256-ajuEbieWjTCNjdRZuGUwvStZwjx260jmY0m+ZqNd7ec=";
  };

  postPatch = ''
    sed -i -e '/install_requires/,/\]/{/beets/d}' setup.py
    sed -i -e '/namespace_packages/d' setup.py
    sed -i -e 's/mediafile~=0.6.0/mediafile>=0.6.0/' setup.py
  '';

  nativeBuildInputs = [ beets ];

  propagatedBuildInputs = with pythonPackages; [ mediafile ];

  preCheck = ''
    HOME=$TEMPDIR
  '';

  meta = {
    homepage = "https://github.com/Holzhaus/beets-extrafiles";
    description = "A plugin for beets that copies additional files and directories during the import process";
    license = lib.licenses.mit;
  };
}
