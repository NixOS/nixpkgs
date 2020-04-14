{ stdenv
, fetchFromGitHub
, buildPythonApplication
, docopt, anytree
}:

buildPythonApplication rec {

  pname = "catcli";
  version = "0.5.13";

  src = fetchFromGitHub {
    owner = "deadc0de6";
    repo = pname;
    rev = "v${version}";
    sha256 = "04mrkqmm2c8fhi1h1hddc4yh3dqhcvkmcwzhj0ggn34v7wavgb5i";
  };

  propagatedBuildInputs = [ docopt anytree ];

  postPatch = '' patchShebangs . '';

  meta = with stdenv.lib; {
    description = "The command line catalog tool for your offline data";
    homepage = "https://github.com/deadc0de6/catcli";
    license = licenses.gpl3;
    maintainers = with maintainers; [ petersjt014 ];
    platforms = platforms.linux;
  };
}
