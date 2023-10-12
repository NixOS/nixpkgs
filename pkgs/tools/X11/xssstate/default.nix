{ lib
, stdenv
, fetchgit
, libX11
, libXScrnSaver
}:
stdenv.mkDerivation rec {
  pname = "xssstate";
  #
  # Use the date of the last commit, since there were bug fixes after the 1.1
  # release.
  #
  version = "unstable-2022-09-24";
  src = fetchgit {
    url = "https://git.suckless.org/xssstate/";
    rev = "5d8e9b49ce2970f786f1e5aa12bbaae83900453f";
    hash = "sha256-Aor12tU1I/qNZCdBhZcvNK1FWFh0HYK8CEI29X5yoeA=";
  };

  makeFlags = [ "VERSION=${version}" ];

  installFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ libX11 libXScrnSaver ];

  meta = with lib; {
    description = "A simple tool to retrieve the X screensaver state";
    license = licenses.mit;
    maintainers = with maintainers; [ onemoresuza ];
    platforms = platforms.linux;
  };
}
