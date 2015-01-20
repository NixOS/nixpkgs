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

 version = "1.4.6";

in stdenv.mkDerivation {

  name = "fswatch-${version}";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "0flq8baqzifhmf61zyiipdipvgy4h0kl551clxrhwa8gvzf75im4";
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

  meta = with stdenv.lib; {
    description = "A cross-platform file change monitor with multiple backends";
    homepage = https://github.com/emcrisostomo/fswatch;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };

}
