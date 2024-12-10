{
  lib,
  buildBazelPackage,
  fetchFromGitHub,
  qt6,
  pkg-config,
  bazel,
  ibus,
  unzip,
  xdg-utils,
}:
let
  zip-codes = fetchFromGitHub {
    owner = "musjj";
    repo = "jp-zip-codes";
    rev = "119c888a38032a92e139c52cd26f45bb495c4d54";
    hash = "sha256-uyAL2TcFJsYZACFDAxIQ4LE40Hi4PVrQRnJl5O5+RmU=";
  };
in
buildBazelPackage rec {
  pname = "ibus-mozc";
  version = "2.29.5374.102";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mozc";
    rev = version;
    hash = "sha256-AcIN5sWPBe4JotAUYv1fytgQw+mJzdFhKuVPLR48soA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    pkg-config
    unzip
  ];

  buildInputs = [
    ibus
    qt6.qtbase
  ];

  dontAddBazelOpts = true;
  removeRulesCC = false;

  inherit bazel;

  fetchAttrs = {
    sha256 = "sha256-ToBLVJpAQErL/P1bfWJca2FjhDW5XTrwuJQLquwlrhA=";

    # remove references of buildInputs and zip code files
    preInstall = ''
      rm -rv $bazelOut/external/{ibus,qt_linux,zip_code_*}
    '';
  };

  bazelFlags = [
    "--config"
    "oss_linux"
    "--compilation_mode"
    "opt"
  ];

  bazelTargets = [ "package" ];

  postPatch = ''
    substituteInPlace src/config.bzl \
      --replace-fail "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open" \
      --replace-fail "/usr" "$out"
    substituteInPlace src/WORKSPACE.bazel \
      --replace-fail "https://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip" "file://${zip-codes}/ken_all.zip" \
      --replace-fail "https://www.post.japanpost.jp/zipcode/dl/jigyosyo/zip/jigyosyo.zip" "file://${zip-codes}/jigyosyo.zip"
  '';

  preConfigure = ''
    cd src
  '';

  buildAttrs.installPhase = ''
    runHook preInstall

    unzip bazel-bin/unix/mozc.zip -x "tmp/*" -d /

    # create a desktop file for gnome-control-center
    # copied from ubuntu
    mkdir -p $out/share/applications
    cp ${./ibus-setup-mozc-jp.desktop} $out/share/applications/ibus-setup-mozc-jp.desktop
    substituteInPlace $out/share/applications/ibus-setup-mozc-jp.desktop \
      --replace-fail "@mozc@" "$out"

    runHook postInstall
  '';

  passthru = {
    inherit zip-codes;
  };

  meta = with lib; {
    isIbusEngine = true;
    description = "Japanese input method from Google";
    mainProgram = "mozc_emacs_helper";
    homepage = "https://github.com/google/mozc";
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      gebner
      ericsagnes
      pineapplehunter
    ];
  };
}
