{
  mkKdeDerivation,
  pkg-config,
  gst_all_1,
}:
mkKdeDerivation {
  pname = "kamoso";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { qt6Support = true; })
  ];

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  # requires newer GStreamer
  meta.broken = true;
}
