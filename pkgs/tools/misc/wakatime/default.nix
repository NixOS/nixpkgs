{ stdenv, buildPythonApplication, fetchFromGitHub }:

buildPythonApplication rec {
  name = "wakatime-${version}";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime";
    rev = version;
    sha256 = "1bg8fzd3rdc6na0a7z1d55m2gbnfq6d72mf2jlyzc817r6dr4bfx";
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
