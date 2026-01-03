{
  mkKdeDerivation,
  breeze,
  qtsvg,
}:
mkKdeDerivation {
  pname = "plasma-welcome";

  postPatch = ''
    substituteInPlace src/qml/mock/Mock{Activities,Card,Overview}.qml \
      --replace-fail 'file:" + Private.App.installPrefix + "/share/wallpapers/Next/contents/images' "file://${breeze}/share/wallpapers/Next/contents/images"
  '';

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "plasma-welcome";
}
