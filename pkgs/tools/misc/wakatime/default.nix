{ stdenv, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;
buildPythonApplication rec {
  pname = "wakatime";
  version = "13.0.7";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime";
    rev = version;
    sha256 = "1rnapzaabg962wxrmfcq9lxz0yyqd3mxqbx3dq1ih4w33lf4fi8d";
  };

  # needs more dependencies from https://github.com/wakatime/wakatime/blob/191b302bfb5f272ae928c6d3867d06f3dfcba4a8/dev-requirements.txt
  # especially nose-capturestderr, which we do not package yet.
  doCheck = false;
  checkInputs = [ mock testfixtures pytest glibcLocales ];

  checkPhase = ''
    export HOME=$(mktemp -d) LC_ALL=en_US.utf-8
    pytest tests
  '';

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
  };
}
