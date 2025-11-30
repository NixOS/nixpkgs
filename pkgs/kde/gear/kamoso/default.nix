{
  mkKdeDerivation,
  pkg-config,
  gst_all_1,
  frei0r,
}:
mkKdeDerivation {
  pname = "kamoso";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { qt6Support = true; })
    gst_all_1.gst-plugins-bad
  ];

  qtWrapperArgs = [ "--set FREI0R_PATH ${frei0r}/lib/frei0r-1" ];

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';
}
