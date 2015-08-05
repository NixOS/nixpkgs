{ stdenv
, fetchFromGitHub
, autoreconfHook
, findutils                     # for xargs
, gettext
, libtool
, makeWrapper
, texinfo
}:

stdenv.mkDerivation rec {
  name = "fswatch-${version}";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "09np75m9df2nk7lc5y9wgq467ca6jsd2p5666d5rkzjvy6s0a51n";
  };

  buildInputs = [ autoreconfHook gettext libtool makeWrapper texinfo ];

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
