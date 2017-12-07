{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "beets-copyartifacts";

  src = fetchFromGitHub {
    repo = "beets-copyartifacts";
    owner = "sbarakat";
    rev = "dac4a1605111e24bb5b498aa84cead7c87480834";
    sha256 = "0p5cskfgqinzh48a58hw56f96g9lar3k3g2p0ip1m9kawzf6axng";
  };

  postPatch = ''
    sed -i -e '/install_requires/,/\]/{/beets/d}' setup.py
    sed -i -e '/namespace_packages/d' setup.py
    printf 'from pkgutil import extend_path\n__path__ = extend_path(__path__, __name__)\n' >beetsplug/__init__.py
  '';

  meta = {
    description = "Beets plugin to move non-music files during the import process";
    homepage = https://github.com/sbarakat/beets-copyartifacts;
    license = stdenv.lib.licenses.mit;
  };
}
