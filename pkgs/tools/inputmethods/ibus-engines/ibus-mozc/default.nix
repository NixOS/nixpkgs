{ lib
, buildBazelPackage
, fetchFromGitHub
, qt6
, pkg-config
, bazel
, ibus
, unzip
, xdg-utils
}:
let
  zip-codes = fetchFromGitHub {
    owner = "musjj";
    repo = "jp-zip-codes";
    rev = "94139331b79d8e23cd089fb9ad511ce55079154a";
    hash = "sha256-e+wsJv2cP2wUwVNimWy0eYr32pr7YUy8pJAYDYbk0zo=";
  };
in
buildBazelPackage rec {
  pname = "ibus-mozc";
  version = "2.30.5544.102";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mozc";
    rev = version;
    hash = "sha256-w0bjoMmq8gL7DSehEG7cKqp5e4kNOXnCYLW31Zl9FRs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qt6.wrapQtAppsHook pkg-config unzip ];

  buildInputs = [ ibus qt6.qtbase ];

  dontAddBazelOpts = true;
  removeRulesCC = false;

  inherit bazel;

  fetchAttrs = {
    sha256 = "sha256-+N7AhSemcfhq6j0IUeWZ0DyVvr1l5FbAkB+kahTy3pM=";

    # remove references of buildInputs and zip code files
    preInstall = ''
      rm -rv $bazelOut/external/{ibus,qt_linux,zip_code_*}
    '';
  };

  bazelFlags = [ "--config" "oss_linux" "--compilation_mode" "opt" ];

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
    maintainers = with maintainers; [ gebner ericsagnes pineapplehunter ];
  };
}
