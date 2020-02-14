{ stdenv, fetchFromGitHub
, python2Packages
}:
python2Packages.buildPythonPackage {
  pname = "vncdo";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "vncdotool";
    rev = "5c03a82dcb5a3bd9e8f741f8a8d0c1ce082f2834";
    sha256 = "0k03b09ipsz8vp362x7sx7z68mxgqw9qzvkii2f8j9vx2y79rjsh";
  };

  propagatedBuildInputs = with python2Packages; [
    pillow
    twisted
    pexpect
    nose
    ptyprocess
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/sibson/vncdotool;
    description = "A command line VNC client and python library";
    license = licenses.mit;
    maintainers = with maintainers; [ elitak ];
    platforms = with platforms; linux ++ darwin;
  };

}
