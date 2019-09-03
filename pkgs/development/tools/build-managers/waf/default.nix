{ stdenv, fetchFromGitLab, fetchpatch, python, ensureNewerSourcesForZipFilesHook
# optional list of extra waf tools, e.g. `[ "doxygen" "pytest" ]`
, withTools ? null
}:
let
  wafToolsArg = with stdenv.lib.strings;
    optionalString (!isNull withTools) " --tools=\"${concatStringsSep "," withTools}\"";
in
stdenv.mkDerivation rec {
  pname = "waf";
  version = "2.0.15";

  src = fetchFromGitLab {
    owner = "ita1024";
    repo = "waf";
    rev = "${pname}-${version}";
    sha256 = "0i86dbn6l01n4h4rzyl4mvizqabbqn5w7fywh83z7fxpha13c3bz";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/grahamc/waf/commit/fc1c98f1fb575fb26b867a61cbca79aa894db2ea.patch";
      sha256 = "0kzfrr6nh1ay8nyk0i69nhkkrq7hskn7yw1qyjxrda1y3wxj6jp8";
    })
  ];

  buildInputs = [ python ensureNewerSourcesForZipFilesHook ];

  configurePhase = ''
    python waf-light configure
  '';
  buildPhase = ''
    python waf-light build${wafToolsArg}
  '';
  installPhase = ''
    install waf $out
  '';

  meta = with stdenv.lib; {
    description = "Meta build system";
    homepage    = https://waf.io;
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ vrthra ];
  };
}
