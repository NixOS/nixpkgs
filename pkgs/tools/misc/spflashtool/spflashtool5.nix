{
  lib,
  stdenv,
  callPackage,
  writeText,
  autoPatchelfHook,
  copyDesktopItems,
  makeWrapper,
  python3,
  udevCheckHook,
  fontconfig,
  freetype,
  glib,
  libxrender,
  libxext,
  libx11,
  libsm,
  libice,
  zlib,
  liberation_ttf,
}:
let
  common = callPackage ./common.nix { };

  major = "5";
  minor = "2228";

  # SP Flash Tool SIGFPEs on CBDT color-emoji fonts, so we must bundle own one
  fontconfigConf = writeText "fonts.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <dir prefix="relative">fonts</dir>
      <dir>/usr/share/fonts</dir>
      <dir>/usr/local/share/fonts</dir>
      <dir prefix="xdg">fonts</dir>
      <include ignore_missing="yes">${fontconfig.out}/etc/fonts/conf.d</include>
      <cachedir prefix="xdg">fontconfig</cachedir>
      <cachedir>/var/cache/fontconfig</cachedir>
      <rejectfont>
        <pattern>
          <patelt name="family">
            <string>Noto Color Emoji</string>
          </patelt>
        </pattern>
      </rejectfont>
      <rejectfont>
        <pattern>
          <patelt name="family">
            <string>EmojiOne Color</string>
          </patelt>
        </pattern>
      </rejectfont>
      <rejectfont>
        <pattern>
          <patelt name="family">
            <string>Twitter Color Emoji</string>
          </patelt>
        </pattern>
      </rejectfont>
    </fontconfig>
  '';

  optionIni = common.mkOptionIni "spflashtool5-option.ini" {
    Trace = {
      DALogLevel = 2;
      DALogChannel = 1;
    };
    Conn = {
      Type = 1;
      DAPreLoader = false;
      USBHighSpeed = true;
      SupportAutoDetect = true;
      Timeout = 3;
    };
    Download = {
      CheckLoadIntegrity = true;
      CheckLibDAMatch = true;
    };
    BLOWN.brom = 0;
    Efuse = {
      Encrypt = 0;
      Jungle = 0;
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "spflashtool${major}";
  version = "${major}.${minor}";

  src = common.mkSrc {
    inherit (finalAttrs) version;
    hash = "sha256-QZYltrfb7Sp+rmNfqgffKfbvBKlF8q0KhUnUyxaafFI=";
  };

  desktopItem = common.mkDesktopItem major;
  desktopItems = [ finalAttrs.desktopItem ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    (python3.withPackages (ps: [ ps.r2pipe ]))
    udevCheckHook
  ];

  strictDeps = true;
  __structuredAttrs = true;

  doInstallCheck = true;

  buildInputs = [
    stdenv.cc.cc.lib
    fontconfig
    freetype
    glib
    libxrender
    libxext
    libx11
    libsm
    libice
    zlib
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r $src $out/opt/spflashtool5
    chmod -R u+w $out/opt/spflashtool5
    chmod +x $out/opt/spflashtool5/flash_tool \
             $out/opt/spflashtool5/bin/assistant

    # Windows-only leftovers
    rm -r $out/opt/spflashtool5/Driver
    rm $out/opt/spflashtool5/*.url

    # Optional Qt4 imageformat plugins whose dependencies no longer exist in nixpkgs
    rm $out/opt/spflashtool5/plugins/imageformats/libq{jpeg,mng,svg,tiff}.so

    python3 ${./r2patch.py} ${./spflashtool5-patches.py} $out/opt/spflashtool5

    install -Dm0644 $src/99-ttyacms.rules \
      -t $out/lib/udev/rules.d/

    install -Dm0644 ${./spflashtool5.png} \
      $out/share/icons/hicolor/256x256/apps/spflashtool5.png

    install -Dm0644 ${liberation_ttf}/share/fonts/truetype/*.ttf \
      -t $out/opt/spflashtool5/fonts/

    install -Dm0644 ${fontconfigConf} \
      $out/opt/spflashtool5/fonts.conf

    install -Dm0644 ${optionIni} $out/opt/spflashtool5/option.ini

    makeWrapper $out/opt/spflashtool5/flash_tool $out/bin/spflashtool5 \
      --prefix LD_LIBRARY_PATH : "$out/opt/spflashtool5:$out/opt/spflashtool5/lib" \
      --set FONTCONFIG_PATH "$out/opt/spflashtool5" \
      --set QT_PLUGIN_PATH "$out/opt/spflashtool5/plugins" \
      --set LC_ALL C  # SP Flash Tool aborts on non-C locales

    runHook postInstall
  '';

  meta = common.mkMeta { inherit major minor; };
})
