{
  lib,
  requireFile,
  stdenv,
}:
# Generic build for Xcode.app
{
  hash,
  version,
}: let
  appName = "Xcode.app";
  xipName = "Xcode_" + version + ".xip";
  # TODO(alexfmpe): Find out how to validate the .xip signature in Linux
  unxipCmd =
    if stdenv.buildPlatform.isDarwin
    then ''
      open -W ${xipName}
      rm -rf ${xipName}
    ''
    else ''
      xar -xf ${xipName}
      rm -rf ${xipName}
      pbzx -n Content | cpio -i
      rm Content Metadata
    '';
  url = "https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_${version}/${xipName}";
  app = requireFile {
    inherit url hash;
    name = appName;
    hashMode = "recursive";
    message = ''
      Unfortunately, we cannot download ${appName} automatically.
      Please go to ${url}
      to download it yourself, and add it to the Nix store by running the following commands.
      Note: download (~ 5GB), extraction and storing of Xcode will take a while

      ${unxipCmd}
      nix-store --add-fixed --recursive sha256 Xcode.app
      rm -rf Xcode.app
    '';
  };
  meta = with lib; {
    homepage = "https://developer.apple.com/downloads/";
    description = "Apple's Xcode SDK";
    license = licenses.unfree;
    platforms = platforms.darwin ++ platforms.linux;
  };
in
  app.overrideAttrs (oldAttrs: oldAttrs // {inherit version meta;})
