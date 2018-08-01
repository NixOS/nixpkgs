{ stdenv, fetchFromGitHub, beets, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "beets-alternatives-${version}";
  version = "0.8.2";

  src = fetchFromGitHub {
    repo = "beets-alternatives";
    owner = "wisp3rwind";
    # This is 0.8.2 with fixes against Beets 1.4.6 and Python 3 compatibility.
    rev = "331eb406786a2d4dc3dd721a534225b087474b1e";
    sha256 = "1avds2x5sp72c89l1j52pszprm85g9sm750jh1dhnyvgcbk91cb5";
  };

  postPatch = ''
    sed -i -e '/long_description/d' setup.py
  '';

  nativeBuildInputs = [ beets pythonPackages.nose ];

  checkPhase = "nosetests";

  meta = {
    description = "Beets plugin to manage external files";
    homepage = https://github.com/geigerzaehler/beets-alternatives;
    license = stdenv.lib.licenses.mit;
  };
}
