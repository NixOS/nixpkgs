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
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "0f6aa14v31gy3j7qx563ml37r8mylpbqfjrz2v5g44zrrg6086w7";
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
