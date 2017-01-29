{ stdenv, fetchFromGitHub, pythonPackages, }:

pythonPackages.buildPythonApplication rec {
  version = "7.0.13";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap";
    rev = "v${version}";
    sha256 = "0108xmp9df6cb1nzw3ym59mir3phgfdgp5d43n44ymsk2cc39xcc";
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
