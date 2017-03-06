{ stdenv, pythonPackages, fetchFromGitHub }:

with pythonPackages;

buildPythonPackage rec {
  namePrefix = "";
  name = "wakatime-${version}";
  version = "7.0.4";

  src = fetchFromGitHub {
    sha256 = "0ghrf0aqb89gjp4pb0398cszi6wzk8chqwd3l5xq6qcgvsq8srq3";
    rev = version;
    repo = "wakatime";
    owner = "wakatime";
  };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "WakaTime command line interface";
    longDescription = ''
      Command line interface to WakaTime used by all WakaTime text editor
      plugins. You shouldn't need to directly use this package unless you
      are building your own plugin or your text editor's plugin asks you
      to install the wakatime CLI interface manually.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ nckx ];
  };
}
