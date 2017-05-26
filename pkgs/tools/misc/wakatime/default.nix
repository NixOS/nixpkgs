{ stdenv, pythonPackages, fetchFromGitHub }:

with pythonPackages;

buildPythonApplication rec {
  name = "wakatime-${version}";
  version = "8.0.2";

  src = fetchFromGitHub {
    sha256 = "0rbjnkzjvz8mgmy44064cz8sib3x5bdjh3ffjhg9r87blnlbmcv1";
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
