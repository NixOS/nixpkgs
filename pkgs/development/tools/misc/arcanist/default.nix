{ stdenv, fetchFromGitHub, php, flex, makeWrapper }:

let
  libphutil = fetchFromGitHub {
    owner = "phacility";
    repo = "libphutil";
    rev = "5fd1af8b4f2b9631e2ceb06bd88d21f2416123c2";
    sha256 = "06zkfkgwni8prr3cnsbf1h4s30k4v00y8ll1bcl6282xynnh3gf6";
  };
  arcanist = fetchFromGitHub {
    owner = "phacility";
    repo = "arcanist";
    rev = "9e82ef979e8148c43b9b8439025d505b1219e213";
    sha256 = "0h7ny8wr3cjn105gyzhd4qmhhccd0ilalslsdjj10nxxw2cgn193";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20160825";

  src = [ arcanist libphutil ];
  buildInputs = [ php makeWrapper flex ];

  unpackPhase = "true";
  buildPhase = ''
    cp -R ${libphutil} libphutil
    cp -R ${arcanist} arcanist
    chmod +w -R libphutil arcanist
    (
      cd libphutil/support/xhpast
      make clean all install
    )
  '';
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp -R libphutil $out/libexec/libphutil
    cp -R arcanist  $out/libexec/arcanist

    ln -s $out/libexec/arcanist/bin/arc $out/bin
    wrapProgram $out/bin/arc \
      --prefix PATH : "${php}/bin"
  '';

  meta = {
    description = "Command line interface to Phabricator";
    homepage    = "http://phabricator.org";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
