{ stdenv, fetchurl, makeWrapper, jre_headless }:

stdenv.mkDerivation rec {
  pname = "graylog";
  version = "3.3.2";

  src = fetchurl {
    url = "https://packages.graylog2.org/releases/graylog/graylog-${version}.tgz";
    sha256 = "0mw0nwj6i681bfsp3psjq377bha2qskkw955pp9h1p8xdyy8cx32";
  };

  dontBuild = true;
  dontStrip = true;

  buildInputs = [ makeWrapper ];
  makeWrapperArgs = [ "--prefix" "PATH" ":" "${jre_headless}/bin" ];

  installPhase = ''
    mkdir -p $out
    cp -r {graylog.jar,lib,bin,plugin} $out
    wrapProgram $out/bin/graylogctl $makeWrapperArgs
  '';

  meta = with stdenv.lib; {
    description = "Open source log management solution";
    homepage    = "https://www.graylog.org/";
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = [ maintainers.fadenb ];
  };
}
