{ stdenv, fetchFromGitHub, beets, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "beets-alternatives-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    repo = "beets-alternatives";
    owner = "geigerzaehler";
    # This is 0.8.2 with fixes against Beets 1.4.6 and Python 3 compatibility.
    rev = "v${version}";
    sha256 = "19160gwg5j6asy8mc21g2kf87mx4zs9x2gbk8q4r6330z4kpl5pm";
  };

  nativeBuildInputs = [ beets pythonPackages.nose ];

  checkPhase = "nosetests";

  meta = {
    description = "Beets plugin to manage external files";
    homepage = https://github.com/geigerzaehler/beets-alternatives;
    maintainers = [ stdenv.lib.maintainers.aszlig ];
    license = stdenv.lib.licenses.mit;
  };
}
