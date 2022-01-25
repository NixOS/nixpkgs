{ lib, stdenv, fetchFromGitLab, python3, ensureNewerSourcesForZipFilesHook
# optional list of extra waf tools, e.g. `[ "doxygen" "pytest" ]`
, withTools ? null
}:
let
  wafToolsArg = with lib.strings;
    optionalString (!isNull withTools) " --tools=\"${concatStringsSep "," withTools}\"";
in
stdenv.mkDerivation rec {
  pname = "waf";
  version = "2.0.23";

  src = fetchFromGitLab {
    owner = "ita1024";
    repo = "waf";
    rev = "${pname}-${version}";
    sha256 = "sha256-AASjkXb3eCVjbuT0GOwhagoNHxG7/XP1Mj0i1U4j13Q=";
  };

  nativeBuildInputs = [ python3 ensureNewerSourcesForZipFilesHook ];

  # waf bin has #!/usr/bin/env python
  buildInputs = [ python3 ];

  configurePhase = ''
    python waf-light configure
  '';
  buildPhase = ''
    python waf-light build${wafToolsArg}
  '';
  installPhase = ''
    install -D waf $out/bin/waf
  '';

  strictDeps = true;

  meta = with lib; {
    description = "Meta build system";
    homepage    = "https://waf.io";
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ vrthra ];
  };
}
