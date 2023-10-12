{ lib
, stdenv
, fetchFromGitHub
, makeBinaryWrapper
, bc
, libnotify
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

  nativeBuildInputs = [ makeBinaryWrapper ];

  # Ensure the following programs are found within $PATH
  wrapperPath = lib.makeBinPath ([
    bc
    feh
    #Needed to fix convert: unable to read font `(null)' @ error/annotate.c/RenderFreetype issue
    (imagemagick.override { ghostscriptSupport = true;})
    libnotify #Needed for the notify-send function call from the script
  ] ++ lib.optionals waylandSupport [ grim slurp wl-clipboard ]
    ++ lib.optionals x11Support [ xcolor ]);

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 farge $out/bin
    wrapProgram $out/bin/farge \
        --prefix PATH : "${finalAttrs.wrapperPath}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "A tool that shows the color value of a given pixel on your screen";
    homepage = "https://github.com/sdushantha/farge";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jtbx justinlime ];
    mainProgram = "farge";
  };
})
