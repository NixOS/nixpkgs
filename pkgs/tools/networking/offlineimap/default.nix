{ stdenv, fetchFromGitHub, pythonPackages, }:

pythonPackages.buildPythonApplication rec {
  version = "7.0.9";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap";
    rev = "v${version}";
    sha256 = "1jrg6n4fpww98vj7gfp2li9ab4pbnrpb249cqa1bs8jjwpmrsqac";
  };

  doCheck = false;

  propagatedBuildInputs = [ pythonPackages.six ];

  meta = {
    description = "Synchronize emails between two repositories, so that you can read the same mailbox from multiple computers";
    homepage = "http://offlineimap.org";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.garbas ];
  };
}
