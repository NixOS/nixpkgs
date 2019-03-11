{ stdenv, fetchFromGitLab, python, ensureNewerSourcesForZipFilesHook }:

stdenv.mkDerivation rec {
  name = "waf-${version}";
  version = "2.0.13";

  src = fetchFromGitLab {
    owner = "ita1024";
    repo = "waf";
    rev = name;
    sha256 = "1r4nyxpf07w98bx9zx0xii97rwsc27s6898xi9ph25p0n6hsdxxg";
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
