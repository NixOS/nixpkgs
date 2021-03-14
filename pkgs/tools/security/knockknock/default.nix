{ lib, fetchFromGitHub, python2Packages, hping }:
let
  rev  = "bf14bbff";
in python2Packages.buildPythonApplication rec {
  pname = "knockknock-r";
  version = rev;

  src = fetchFromGitHub {
    inherit rev;
    owner  = "moxie0";
    repo   = "knockknock";
    sha256 = "1chpfs3w2vkjrgay69pbdr116z1jldv53fi768a1i05fdqhy1px4";
  };

  propagatedBuildInputs = [ python2Packages.pycrypto ];

  # No tests
  doCheck = false;

  patchPhase = ''
    sed -i '/build\//d' setup.py
    substituteInPlace setup.py --replace "/etc" "$out/etc"
    substituteInPlace knockknock.py --replace 'existsInPath("hping3")' '"${hping}/bin/hping3"'
  '';

  meta = with lib; {
    description = "Simple, secure port knocking daemon and client written in Python";
    homepage    = "http://www.thoughtcrime.org/software/knockknock/";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.linux;
  };
}

