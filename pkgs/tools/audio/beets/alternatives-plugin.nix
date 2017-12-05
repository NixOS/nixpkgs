{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "beets-alternatives-${version}";
  version = "0.8.2";

  src = fetchFromGitHub {
    repo = "beets-alternatives";
    owner = "geigerzaehler";
    rev = "v${version}";
    sha256 = "10za6h59pxa13y8i4amqhc6392csml0dl771lssv6b6a98kamsy7";
  };

  postPatch = ''
    sed -i -e '/install_requires/,/\]/{/beets/d}' setup.py
  '';

  propagatedBuildInputs = with pythonPackages; [ futures ];

  meta = {
    description = "Beets plugin to manage external files";
    homepage = https://github.com/geigerzaehler/beets-alternatives;
    license = stdenv.lib.licenses.mit;
  };
}
