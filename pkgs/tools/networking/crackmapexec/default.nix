{ lib, python2Packages, fetchFromGitHub, pywerview }:

python2Packages.buildPythonApplication rec {
  name = "crackmapexec-git-2017-05-15";

  src = fetchFromGitHub {
    owner = "byt3bl33d3r";
    repo = "CrackMapExec";
    rev = "e79519750178e7b26455c28c17916d88508e8770";
    sha256 = "1dy5p85k33jyjkp749qp7y140w4d02x2zsjv3hvql78nprlamkq7";
  };

  postPatch = ''
    substituteInPlace setup.py --replace bs4 beautifulsoup4
  '';

  propagatedBuildInputs = with python2Packages; [
    pycrypto termcolor gevent netaddr pyopenssl msgpack impacket requests
    pylnk beautifulsoup4 pywerview
  ];

  namePrefix = "";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "swiss army knife for pentesting networks";
    license = licenses.bsd2;
  };
}
