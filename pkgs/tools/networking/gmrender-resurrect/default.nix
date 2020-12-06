{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkgconfig, makeWrapper, gstreamer
, gst-plugins-base, gst-plugins-good, gst-plugins-bad, gst-plugins-ugly, gst-libav, libupnp }:

let
  version = "0.0.8";

  makePluginPath = plugins: builtins.concatStringsSep ":" (map (p: p + "/lib/gstreamer-1.0") plugins);

  pluginPath = makePluginPath [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav ];
in
  stdenv.mkDerivation {
    pname = "gmrender-resurrect";
    inherit version;

    src = fetchFromGitHub {
      owner = "hzeller";
      repo = "gmrender-resurrect";
      rev = "v${version}";
      sha256 = "14i5jrry6qiap5l2x2jqj7arymllajl3wgnk29ccvr8d45zp4jn1";
    };

    patches = [
      (fetchpatch {
        url = "https://github.com/hzeller/gmrender-resurrect/commit/dc8c4d4dc234311b3099e7f1efadf5d9733c81e9.patch";
        sha256 = "0fqi58viaq9jg5h5j1725qrach4c3wmfmh0q43q4r8az2pn7dszw";
        name = "libupnp.patch";
      })
    ];

    buildInputs = [ gstreamer libupnp ];
    nativeBuildInputs = [ autoreconfHook pkgconfig makeWrapper ];

    postInstall = ''
      for prog in "$out/bin/"*; do
          wrapProgram "$prog" --suffix GST_PLUGIN_SYSTEM_PATH_1_0 : "${pluginPath}"
      done
    '';

    meta = with stdenv.lib; {
      description = "Resource efficient UPnP/DLNA renderer, optimal for Raspberry Pi, CuBox or a general MediaServer";
      homepage = "https://github.com/hzeller/gmrender-resurrect";
      license = licenses.gpl2;
      platforms = platforms.linux;
      maintainers = with maintainers; [ koral ashkitten ];
    };
  }
