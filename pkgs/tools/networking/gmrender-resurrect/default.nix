{ stdenv, fetchFromGitHub, fetchpatch, autoconf, automake, pkgconfig, makeWrapper
, gstreamer, gst-plugins-base, gst-plugins-good, gst-plugins-bad, gst-plugins-ugly, gst-libav, libupnp }:

let version = "v0.0.8"; in

stdenv.mkDerivation {
  pname = "gmrender-resurrect";
  inherit version;

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "gmrender-resurrect";
    rev = version;
    sha256 = "14i5jrry6qiap5l2x2jqj7arymllajl3wgnk29ccvr8d45zp4jn1";
  };

  preConfigurePhases = "autoconfPhase";

  autoconfPhase = "./autogen.sh";

  buildInputs = [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav libupnp ];
  nativeBuildInputs = [ autoconf automake pkgconfig makeWrapper ];

  postInstall = ''
    for prog in "$out/bin/"*; do
        wrapProgram "$prog" --suffix GST_PLUGIN_SYSTEM_PATH_1_0 : "${gstreamer}/lib/gstreamer-1.0:${gst-plugins-base}/lib/gstreamer-1.0:${gst-plugins-good}/lib/gstreamer-1.0:${gst-plugins-bad}/lib/gstreamer-1.0:${gst-plugins-ugly}/lib/gstreamer-1.0:${gst-libav}/lib/gstreamer-1.0"
    done
  '';

  meta = with stdenv.lib; {
    description = "Resource efficient UPnP/DLNA renderer, optimal for Raspberry Pi, CuBox or a general MediaServer";
    homepage = https://github.com/hzeller/gmrender-resurrect;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.koral maintainers.ashkitten ];
  };
}
