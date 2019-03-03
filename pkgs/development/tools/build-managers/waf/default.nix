{ stdenv, fetchFromGitLab, python, ensureNewerSourcesForZipFilesHook }:

stdenv.mkDerivation rec {
  name = "waf-${version}";
  version = "2.0.14";

  src = fetchFromGitLab {
    owner = "ita1024";
    repo = "waf";
    rev = name;
    sha256 = "006a4wb9i569pahs8ji86hrv58g2hm8xikgchnll3bdqgxllhnrs";
  };

  buildInputs = [ python ensureNewerSourcesForZipFilesHook ];

  configurePhase = ''
    python waf-light configure
  '';
  buildPhase = ''
    python waf-light build
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
