{ stdenv
, fetchurl
, lib
, autoPatchelfHook
, wrapQtAppsHook
, gmpxx
, gnustep
, libbsd
, libffi_3_3
, ncurses6
, undmg
}:
let
  version = "5.7.0";
  rev = "v4";

  linux = {
    src = fetchurl {
      url = "https://d2ap6ypl1xbe4k.cloudfront.net/Hopper-${rev}-${version}-Linux-demo.pkg.tar.xz";
      hash = "sha256-yvNNt10GRbNCr4ycG3U5kkqe+lVtiTh78iqAdY7Y5WQ=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      wrapQtAppsHook
    ];

    buildInputs = [
      gnustep.libobjc
      libbsd
      libffi_3_3
      ncurses6
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mkdir -p $out/lib
      mkdir -p $out/share

      cp $sourceRoot/opt/hopper-${rev}/bin/Hopper $out/bin/hopper
      cp \
        --archive \
        $sourceRoot/opt/hopper-${rev}/lib/libBlocksRuntime.so* \
        $sourceRoot/opt/hopper-${rev}/lib/libdispatch.so* \
        $sourceRoot/opt/hopper-${rev}/lib/libgnustep-base.so* \
        $sourceRoot/opt/hopper-${rev}/lib/libHopperCore.so* \
        $sourceRoot/opt/hopper-${rev}/lib/libkqueue.so* \
        $sourceRoot/opt/hopper-${rev}/lib/libobjcxx.so* \
        $sourceRoot/opt/hopper-${rev}/lib/libpthread_workqueue.so* \
        $out/lib

      cp -r $sourceRoot/usr/share $out

      runHook postInstall
    '';

    postFixup = ''
      substituteInPlace "$out/share/applications/hopper-${rev}.desktop" \
        --replace "Exec=/opt/hopper-${rev}/bin/Hopper" "Exec=$out/bin/hopper"
    '';
  };

  darwin = {
    src = fetchurl {
      url = "https://d2ap6ypl1xbe4k.cloudfront.net/Hopper-${version}-demo.dmg";
      hash = "sha256-MhquCcgei+wpocKhVOF0uAkPT0U58w9SE5yhYX7Cad0=";
    };
    appName = "Hopper Disassembler ${rev}.app";

    nativeBuildInputs = [ undmg ];

    installPhase = ''
      runHook preInstall

      APP_DIR="$out/Applications/$appName"
      mkdir -p "$APP_DIR"
      cp -Tr "$appName" "$APP_DIR"

      mkdir -p "$out/bin"
      cat << EOF > "$out/bin/hopper"
      #!${stdenv.shell}
      exec "$APP_DIR/Contents/MacOS/hopper" "$@"
      EOF
      chmod +x "$out/bin/hopper"

      runHook postInstall
    '';
  };

  args = if stdenv.targetPlatform.isDarwin then darwin else linux;

in stdenv.mkDerivation ({
  pname = "hopper";
  inherit version rev;

  sourceRoot = ".";

  meta = with lib; {
    homepage = "https://www.hopperapp.com/index.html";
    description = "A macOS and Linux Disassembler";
    downloadPage = "https://www.hopperapp.com/download.html";
    changelog = "https://www.hopperapp.com/rss/html_changelog.php";
    license = licenses.unfree;
    mainProgram = "hopper";
    maintainers = with maintainers; [
      luis
      Enteee
    ];
    platforms =
      [ "x86_64-linux" /* aarch64-linux is not supported */ ] ++
      platforms.darwin;
  };
} // args)
