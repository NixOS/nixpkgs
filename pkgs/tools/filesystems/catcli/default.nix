{ stdenv
, fetchFromGitHub
, buildPythonApplication
, docopt, anytree
}:

buildPythonApplication rec {

  pname = "catcli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "deadc0de6";
    repo = pname;
    rev = "v${version}";
    sha256 = "0myhvflph4fayl2bg8m9a7prh5pcnvnb75p0jb4jpmbx7jyn7ihp";
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
