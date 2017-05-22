{ lib, python2Packages, fetchFromGitHub, pywerview }:

python2Packages.buildPythonApplication rec {
  name = "pywerview-git-2017-04-07";

  src = fetchFromGitHub {
    owner = "the-useless-one";
    repo = "pywerview";
    rev = "2d74947a975486f49e94299ac270161c92cf7912";
    sha256 = "0v0rj534ia78fglh2jh6spjaivvnm50gzf7v4cjh52kvz9frzcsq";
  };

  postPatch = ''
    substituteInPlace setup.py --replace bs4 beautifulsoup4
  '';

  propagatedBuildInputs = with python2Packages; [
    pycrypto impacket beautifulsoup4 pyopenssl
  ];

  namePrefix = "";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "swiss army knife for pentesting networks";
    license = licenses.bsd2;
  };
}
