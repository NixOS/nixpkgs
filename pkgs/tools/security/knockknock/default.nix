{ stdenv, fetchFromGitHub, pythonPackages, buildPythonApplication, hping }:

pythonPackages.buildPythonApplication rec {
  rev  = "bf14bbff";
  name = "knockknock-r${rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "moxie0";
    repo   = "knockknock";
    sha256 = "1chpfs3w2vkjrgay69pbdr116z1jldv53fi768a1i05fdqhy1px4";
  };

  propagatedBuildInputs = [ pythonPackages.pycrypto ];

  patchPhase = ''
    sed -i '/build\//d' setup.py
    substituteInPlace setup.py --replace "/etc" "$out/etc"
    substituteInPlace knockknock.py --replace 'existsInPath("hping3")' '"${hping}/bin/hping3"'
  '';

  meta = with stdenv.lib; {
    description = "Simple, secure port knocking daemon and client written in Python";
    homepage    = "http://www.thoughtcrime.org/software/knockknock/";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.linux;
  };
}

