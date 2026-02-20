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
  version = "0.3.1";

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
    sha256 = "sha256-e8X/Ab4E6FmPpbRx4y8UZbuPTFaq2hz4Ye8dbKTqGUc=";
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

  meta = {
    description = "Resource efficient UPnP/DLNA renderer, optimal for Raspberry Pi, CuBox or a general MediaServer";
    mainProgram = "gmediarender";
    homepage = "https://github.com/hzeller/gmrender-resurrect";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      koral
      hzeller
    ];
  };
}
