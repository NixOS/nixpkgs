{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  makeWrapper,
  gstreamer,
  gst-plugins-base,
  gst-plugins-good,
  gst-plugins-bad,
  gst-plugins-ugly,
  gst-libav,
  libupnp,
}:

let
  version = "0.1";

  pluginPath = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ];
in
stdenv.mkDerivation {
  pname = "gmrender-resurrect";
  inherit version;

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "gmrender-resurrect";
    rev = "v${version}";
    sha256 = "sha256-FR5bMjwPnY1/PNdPRiaxoY1keogq40M06YOaoks4zVY=";
  };

  buildInputs = [
    gstreamer
    libupnp
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  postInstall = ''
    for prog in "$out/bin/"*; do
        wrapProgram "$prog" --suffix GST_PLUGIN_SYSTEM_PATH_1_0 : "${pluginPath}"
    done
  '';

  meta = with lib; {
    description = "Resource efficient UPnP/DLNA renderer, optimal for Raspberry Pi, CuBox or a general MediaServer";
    mainProgram = "gmediarender";
    homepage = "https://github.com/hzeller/gmrender-resurrect";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      koral
      hzeller
    ];
  };
}
