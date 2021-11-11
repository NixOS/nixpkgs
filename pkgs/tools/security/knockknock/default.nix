{ lib, fetchFromGitHub, python2Packages, hping }:

python2Packages.buildPythonApplication rec {
  pname = "knockknock";
  version = "unstable-2012-09-17";

  src = fetchFromGitHub {
    owner  = "moxie0";
    repo   = "knockknock";
    rev    = "bf14bbffc5f1d2105cd1d955dabca26b3faa0db4";
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
    homepage    = "https://github.com/moxie0/knockknock";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.unix;
  };
}

