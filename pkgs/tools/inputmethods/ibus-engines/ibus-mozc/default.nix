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
    rev = "a1eed9bae0ba909c8c8f5387008b08ff490f5e57";
    hash = "sha256-VfI8qAMPPCC2H4vjm4a6sAmSwc1YkXlMyLm1cnufvrU=";
  };
in
buildBazelPackage rec {
  pname = "ibus-mozc";
  version = "2.29.5268.102";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mozc";
    rev = version;
    hash = "sha256-B7hG8OUaQ1jmmcOPApJlPVcB8h1Rw06W5LAzlTzI9rU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qt6.wrapQtAppsHook pkg-config unzip ];

  buildInputs = [ ibus qt6.qtbase ];

  dontAddBazelOpts = true;
  removeRulesCC = false;

  inherit bazel;

  fetchAttrs = {
    sha256 = "sha256-17QHh1MJUu8OK/T+WSpLXEx83DmRORLN7yLzILqP7vw=";

    # remove references of buildInputs
    preInstall = ''
      rm -rv $bazelOut/external/{ibus,qt_linux}
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
