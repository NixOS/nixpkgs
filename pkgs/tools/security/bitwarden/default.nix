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
  version = "1.29.1";

  src = fetchurl {
    url = "https://github.com/bitwarden/desktop/releases/download/v${version}/Bitwarden-${version}-amd64.deb";
    sha256 = "0rxy19bazi7a6m2bpx6wadg5d9p0k324h369vgr5ppmxb69d6zp8";
  };

  desktopItem = makeDesktopItem {
    name = "bitwarden";
    exec = "bitwarden %U";
    icon = "bitwarden";
    comment = "A secure and free password manager for all of your devices";
    desktopName = "Bitwarden";
    categories = "Utility";
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
