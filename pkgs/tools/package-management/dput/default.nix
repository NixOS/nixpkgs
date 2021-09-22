{ fetchzip, python39Packages }:

let
  inherit (python39Packages) buildPythonApplication;
in
buildPythonApplication rec {
  propagatedBuildInputs = with python39Packages;
    [ debian gpgme pygpgme testscenarios pkgs.gpgme setuptools ];
  src = fetchzip {
    url = "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/dput/1.1.0ubuntu1/dput_1.1.0ubuntu1.tar.xz";
    sha256 = "1dgmyhmpnw71y1qs9z6npi9m46qh2vjs5g2vvaj1ak57333w2f7d";
  };
  name = "dput";
  version = "1.1.0";
  doCheck = false;
}
