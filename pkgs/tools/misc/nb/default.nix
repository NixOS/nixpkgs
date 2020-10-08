{ stdenv, fetchgit }:

let
  version = "5.5.1";
  name = "nb-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchgit {
    url    = "https://github.com/xwmx/nb.git";
    rev    = version;
    sha256 = "LXgLzO+rPCalkWBF79U2Y8r+wtTfSMMuHRYlT/wKd3g=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin;
    chmod +x nb;
    cp nb $out/bin/nb;
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/xwmx/nb";
    description = "A command line note-taking, bookmarking, archiving, and knowledge base application.";
    license = licenses.agpl3Only;
    platforms = platforms.all;
  };
}
