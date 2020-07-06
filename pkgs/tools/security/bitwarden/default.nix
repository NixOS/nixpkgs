{ atomEnv
, autoPatchelfHook
, dpkg
, fetchurl
, libsecret
, makeDesktopItem
, makeWrapper
, stdenv
, udev
, wrapGAppsHook
}:

let
  inherit (stdenv.hostPlatform) system;

  pname = "bitwarden";

  version = {
    x86_64-linux = "1.19.0";
  }.${system} or "";

  sha256 = {
    x86_64-linux = "16qlgnqyi0jwzlz8wg2628jhh83xsk46bl6p4dnwi0ay07lhab9w";
  }.${system} or "";

  meta = with stdenv.lib; {
    description = "A secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kiwi ];
    platforms = [ "x86_64-linux" ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version meta;

    src = fetchurl {
      url = "https://github.com/bitwarden/desktop/releases/download/"
      + "v${version}/Bitwarden-${version}-amd64.deb";
      inherit sha256;
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

    buildInputs = [ libsecret ] ++ atomEnv.packages;

    nativeBuildInputs = [ dpkg makeWrapper autoPatchelfHook wrapGAppsHook ];

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
      udev.lib
    ];

    postFixup = ''
      makeWrapper $out/opt/Bitwarden/bitwarden $out/bin/bitwarden \
        --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ libsecret stdenv.cc.cc ] }" \
        "''${gappsWrapperArgs[@]}"
    '';
  };

in if stdenv.isDarwin
then throw "Bitwarden has not been packaged for macOS yet"
else linux
