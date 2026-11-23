{
  mkKdeDerivation,
  pkg-config,
  kirigami-addons,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  frei0r,
}:
mkKdeDerivation {
  pname = "kamoso";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    kirigami-addons
    gst-plugins-base
    (gst-plugins-good.override { qt6Support = true; })
    gst-plugins-bad
  ];

  qtWrapperArgs = [
    "--set"
    "FREI0R_PATH"
    "${frei0r}/lib/frei0r-1"
  ];

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';
}
