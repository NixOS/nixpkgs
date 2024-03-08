{ lib
, stdenv
, fetchgit
, libX11
, libXScrnSaver
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xssstate";
  version = "1.1-unstable-2022-09-24";

  src = fetchgit {
    url = "https://git.suckless.org/xssstate/";
    rev = "5d8e9b49ce2970f786f1e5aa12bbaae83900453f";
    hash = "sha256-Aor12tU1I/qNZCdBhZcvNK1FWFh0HYK8CEI29X5yoeA=";
  };

  buildInputs = [
    libX11
    libXScrnSaver
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=${finalAttrs.version}"
  ];

  meta = with lib; {
    description = "A simple tool to retrieve the X screensaver state";
    license = licenses.mit;
    maintainers = with maintainers; [ onemoresuza ];
    platforms = platforms.linux;
    mainProgram = "xssstate";
  };
})
