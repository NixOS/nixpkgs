{ stdenv, fetchFromGitHub, pythonPackages, }:

pythonPackages.buildPythonApplication rec {
  version = "7.0.12";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap";
    rev = "v${version}";
    sha256 = "1i83p40lxjqnvh88x623iydrwnsxib1k91qbl9myc4hi5i4fnr6x";
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
