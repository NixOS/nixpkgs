{ stdenv, fetchFromGitLab, python, ensureNewerSourcesForZipFilesHook
# optional list of extra waf tools, e.g. `[ "doxygen" "pytest" ]`
, withTools ? null
}:
let
  wafToolsArg = with stdenv.lib.strings;
    optionalString (!isNull withTools) " --tools=\"${concatStringsSep "," withTools}\"";
in
stdenv.mkDerivation rec {
  pname = "waf";
  version = "2.0.19";

  src = fetchFromGitLab {
    owner = "ita1024";
    repo = "waf";
    rev = "${pname}-${version}";
    sha256 = "1ydmx20blr776qnmnqp0whyiy81a3glln49m9fva2cmampmandpb";
  };

  buildInputs = [ python ensureNewerSourcesForZipFilesHook ];

  configurePhase = ''
    python waf-light configure
  '';
  buildPhase = ''
    python waf-light build${wafToolsArg}
  '';
  installPhase = ''
    install -D waf $out/bin/waf
  '';

  meta = with stdenv.lib; {
    description = "Meta build system";
    homepage    = https://waf.io;
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ vrthra ];
  };
}
