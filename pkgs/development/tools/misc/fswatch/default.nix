{ stdenv
, fetchFromGitHub
, autoconf
, automake114x
, findutils                     # for xargs
, gettext_0_19
, libtool
, makeWrapper
, texinfo
}:

let

 version = "1.4.5.3";

in stdenv.mkDerivation {

  name = "fswatch-${version}";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "05jphslvfgp94vd86myjw5q4wgbayj8avw49h4a4npkwhn93d11j";
  };

  buildInputs = [ autoconf automake114x gettext_0_19 libtool makeWrapper texinfo ];

  preConfigure = ''
    ./autogen.sh
  '';

  postFixup = ''
    for prog in fswatch-run fswatch-run-bash; do
      wrapProgram $out/bin/$prog \
        --prefix PATH "${findutils}/bin"
    done
  '';

  meta = {
    description = "A cross-platform file change monitor with multiple backends";
    homepage = https://github.com/emcrisostomo/fswatch;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
  };

}
