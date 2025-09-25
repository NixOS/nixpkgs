{
  stdenv,
  fetchurl,
  lib,
  nodejs,
  node-pre-gyp,
  node-gyp,
  python3,
  util-linux,
  ffmpeg-headless,

  # Current derivation only supports linux-x86_64 (contributions welcome, without libTensorflow builtin webassembly can be used)
  useLibTensorflow ? stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isLinux,

  ncVersion,
}:
let
  latestVersionForNc = {
    "31" = {
      version = "9.0.3";
      appHash = "sha256-G7SDE72tszifozfT3vNxHW6WmMqQKhrSayQVANQaMbs=";
      modelHash = "sha256-dB4ot/65xisR700kUXg3+Y+SkrpQO4mWrFfp+En0QEE=";
    };
  };
  currentVersionInfo =
    latestVersionForNc.${ncVersion}
      or (throw "recognize currently does not support nextcloud version ${ncVersion}");
in
stdenv.mkDerivation rec {
  pname = "nextcloud-app-recognize";
  inherit (currentVersionInfo) version;

  srcs = [
    (fetchurl {
      url = "https://github.com/nextcloud/recognize/releases/download/v${version}/recognize-${version}.tar.gz";
      hash = currentVersionInfo.appHash;
    })

    (fetchurl {
      url = "https://github.com/nextcloud/recognize/archive/refs/tags/v${version}.tar.gz";
      hash = currentVersionInfo.modelHash;
    })
  ]
  ++ lib.optionals useLibTensorflow [
    (fetchurl {
      # For version see LIBTENSORFLOW_VERSION in https://github.com/tensorflow/tfjs/blob/master/tfjs-node/scripts/deps-constants.js
      url = "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-2.9.1.tar.gz";
      hash = "sha256-f1ENJUbj214QsdEZRjaJAD1YeEKJKtPJW8pRz4KCAXM=";
    })
  ];

  unpackPhase = ''
    # Merge the app and the models from github
    tar -xzpf "${builtins.elemAt srcs 0}" recognize
    tar -xzpf "${builtins.elemAt srcs 1}" -C recognize --strip-components=1 recognize-${version}/models
  ''
  + lib.optionalString useLibTensorflow ''
    # Place the tensorflow lib at the right place for building
    tar -xzpf "${builtins.elemAt srcs 2}" -C recognize/node_modules/@tensorflow/tfjs-node/deps
  '';

  postPatch = ''
    # Make it clear we are not reading the node in settings
    sed -i "/'node_binary'/s:'""':'Nix Controlled':" recognize/lib/Service/SettingsService.php

    # Replace all occurrences of node (and check that we actually removed them all)
    test "$(grep "get[a-zA-Z]*('node_binary'" recognize/lib/**/*.php | wc -l)" -gt 0
    substituteInPlace recognize/lib/**/*.php \
      --replace-quiet "\$this->settingsService->getSetting('node_binary')" "'${lib.getExe nodejs}'" \
      --replace-quiet "\$this->config->getAppValueString('node_binary', '""')" "'${lib.getExe nodejs}'" \
      --replace-quiet "\$this->config->getAppValueString('node_binary')" "'${lib.getExe nodejs}'"
    test "$(grep "get[a-zA-Z]*('node_binary'" recognize/lib/**/*.php | wc -l)" -eq 0

    # Skip trying to install it... (less warnings in the log)
    sed  -i '/public function run/areturn ; //skip' recognize/lib/Migration/InstallDeps.php

    ln -s ${lib.getExe ffmpeg-headless} recognize/node_modules/ffmpeg-static/ffmpeg
  '';

  nativeBuildInputs = lib.optionals useLibTensorflow [
    nodejs
    node-pre-gyp
    node-gyp
    python3
    util-linux
  ];

  buildPhase = lib.optionalString useLibTensorflow ''
    runHook preBuild

    cd recognize

    # Install tfjs dependency
    export CPPFLAGS="-I${lib.getDev nodejs}/include/node -Ideps/include"
    cd node_modules/@tensorflow/tfjs-node
    node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs}
    rm -r ./build-tmp-napi-v*/
    cd -

    # Test tfjs returns exit code 0
    node src/test_libtensorflow.js
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    approot="$(dirname $(dirname $(find -path '*/appinfo/info.xml' | head -n 1)))"
    if [ -d "$approot" ]; then
      mv "$approot/" $out
      chmod -R a-w $out
    fi

    runHook postInstall
  '';

  meta = with lib; {
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ beardhatcode ];
    longDescription = ''
      Nextcloud app that does Smart media tagging and face recognition with on-premises machine learning models.
      This app goes through your media collection and adds fitting tags, automatically categorizing your photos and music.
    '';
    homepage = "https://apps.nextcloud.com/apps/recognize";
    description = "Smart media tagging for Nextcloud: recognizes faces, objects, landscapes, music genres";
    changelog = "https://github.com/nextcloud/recognize/blob/v${version}/CHANGELOG.md";
  };
}
