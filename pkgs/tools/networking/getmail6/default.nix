{ fetchFromGitHub, python3Packages, lib }:

python3Packages.buildPythonApplication rec {
  pname = "getmail6";
  version = "6.16";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1y373nzbffjjjs43441cn3wrb0yq1mw2vqixhizbzdacrs45xbfa";
  };

  doCheck = false;

  pythonImportsCheck = [ "getmailcore" ];

  postPatch = ''
    # getmail spends a lot of effort to build an absolute path for
    # documentation installation; too bad it is counterproductive now
    sed -e '/datadir or prefix,/d' -i setup.py
  '';

  meta = with lib; {
    description = "A program for retrieving mail";
    homepage = "https://getmail6.org";
    updateWalker = true;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbe ];
  };
}
