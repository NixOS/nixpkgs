{ atomEnv
, autoPatchelfHook
, dpkg
, fetchurl
, lib
, libsecret
, libxshmfence
, makeDesktopItem
, makeWrapper
, stdenv
, udev
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "bitwarden";
  version = "1.31.3";

  src = fetchurl {
    url = "https://github.com/bitwarden/desktop/releases/download/v${version}/Bitwarden-${version}-amd64.deb";
    sha256 = "sha256-ASL4+FZh5st3V5Z+jsfvLD26hG9KNVI+tht7kL8lbL4=";
  };

  desktopItem = makeDesktopItem {
    name = "bitwarden";
    exec = "bitwarden %U";
    icon = "bitwarden";
    comment = "A secure and free password manager for all of your devices";
    desktopName = "Bitwarden";
    categories = [ "Utility" ];
  };

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  dontWrapGApps = true;

  nativeBuildInputs = [ dpkg makeWrapper autoPatchelfHook wrapGAppsHook ];

  buildInputs = [ libsecret libxshmfence ] ++ atomEnv.packages;

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p "$out/bin"
    cp -R "opt" "$out"
    cp -R "usr/share" "$out/share"
    chmod -R g-w "$out"

    # Desktop file
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* "$out/share/applications"
  '';

  runtimeDependencies = [
    (lib.getLib udev)
  ];

  postFixup = ''
    makeWrapper $out/opt/Bitwarden/bitwarden $out/bin/bitwarden \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libsecret stdenv.cc.cc ] }" \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "A secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kiwi ];
    platforms = [ "x86_64-linux" ];
  };
}
