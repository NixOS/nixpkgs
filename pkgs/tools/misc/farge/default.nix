{ lib
, stdenv
, fetchFromGitHub
, bash
, bc
, feh
, grim
, imagemagick
, slurp
, wl-clipboard
, xcolor
, waylandSupport ? true
, x11Support ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "farge";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "sdushantha";
    repo = "farge";
    rev = "2ff6669e2350644d4f0b1bd84526efe5eae3c302";
    hash = "sha256-vCMuFMGcI4D4EzbSsXeNGKNS6nBFkfTcAmSzb9UMArc=";
  };

  buildInputs = [ bash bc feh imagemagick ]
    ++ lib.optionals waylandSupport [ grim slurp wl-clipboard ]
    ++ lib.optionals x11Support [ xcolor ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 farge $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "A tool that shows the color value of a given pixel on your screen";
    homepage = "https://github.com/sdushantha/farge";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jtbx ];
    mainProgram = "farge";
  };
})
