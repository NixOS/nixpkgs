{ stdenv, pythonPackages, fetchFromGitHub }:

with pythonPackages;

buildPythonPackage rec {
  namePrefix = "";
  name = "wakatime-${version}";
  version = "7.0.4";

  src = fetchFromGitHub {
    sha256 = "1cddabx9x11d2nxxcqlf4piysjnpfici0n5qy3n9gw81asz1djhf";
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
