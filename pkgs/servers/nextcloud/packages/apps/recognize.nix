{
  stdenv,
  fetchurl,
  lib,
  nodejs,
  python3,
  util-linux,
  ffmpeg,

  # Current derivation only suports linux-x86_64 (contributions welcome, without libTensorflow builtin webassembly can be used)
  useLibTensorflow ? stdenv.isx86_64 && stdenv.isLinux,

  ncVersion,
}:
let
  latestVersionForNc = {
    "30" = {
      version = "8.2.0";
      appHash = "sha256-CAORqBdxNQ0x+xIVY2zI07jvsKHaa7eH0jpVuP0eSW4=";
      modelHash = "sha256-s8MQOLU490/Vr/U4GaGlbdrykOAQOKeWE5+tCzn6Dew=";
    };
    "29" = {
      version = "7.1.0";
      appHash = "sha256-qR4SrTHFAc4YWiZAsL94XcH4VZqYtkRLa0y+NdiFZus=";
      modelHash = "sha256-M/j5wVOBLR7xMVJQWDUWAzLajRUBYEzHSNBsRSBUgfM=";
    };
    "28" = {
      # Once this version is no longer supported, we can remove the getAppValue replacements below
      # The getAppValueString stuff will need to remain
      version = "6.1.0";
      appHash = "sha256-225r2JnDOoURvLmzpmHp/QL6GDx9124/YTywbxH3/rk=";
      modelHash = "sha256-4mhQM/ajpwjqTb8jSbEIdtSRrWZEOaMZQXAwcfSRQ/M=";
    };
  };
  currentVersionInfo = latestVersionForNc.${ncVersion};
in
stdenv.mkDerivation rec {

  pname = "nextcloud-app-recognise";
  version = currentVersionInfo.version;

  srcs =
    [
      (fetchurl {
        inherit version;
        url = "https://github.com/nextcloud/recognize/releases/download/v${version}/recognize-${version}.tar.gz";
        hash = currentVersionInfo.appHash;
      })

      (fetchurl {
        inherit version;
        url = "https://github.com/nextcloud/recognize/archive/refs/tags/v${version}.tar.gz";
        hash = currentVersionInfo.modelHash;
      })
    ]
    ++ lib.optionals useLibTensorflow [
      (fetchurl rec {
        # For version see LIBTENSORFLOW_VERSION in https://github.com/tensorflow/tfjs/blob/master/tfjs-node/scripts/deps-constants.js
        version = "2.9.1";
        url = "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-${version}.tar.gz";
        hash = "sha256-f1ENJUbj214QsdEZRjaJAD1YeEKJKtPJW8pRz4KCAXM=";
      })
    ];

  unpackPhase =
    ''
      # Merge the app and the models from github
      tar -xzpf "${builtins.elemAt srcs 0}" recognize;
      tar -xzpf "${builtins.elemAt srcs 1}" -C recognize --strip-components=1 recognize-${version}/models
    ''
    + lib.optionalString useLibTensorflow ''
      # Place the tensorflow lib at the right place for building
      tar -xzpf "${builtins.elemAt srcs 2}" -C recognize/node_modules/@tensorflow/tfjs-node/deps
    '';

  postPatch = ''
    # Make it clear we are not reading the node in settings
    sed -i "/'node_binary'/s:'""':'Nix Controled':" recognize/lib/Service/SettingsService.php

    # Replace all occurences of node (and check that we actually remved them all)
    test "$(grep "get[a-zA-Z]*('node_binary'" recognize/lib/**/*.php | wc -l)" -gt 0
    substituteInPlace recognize/lib/**/*.php \
      --replace-quiet "\$this->settingsService->getSetting('node_binary')" "'${nodejs}/bin/node'" \
      --replace-quiet "\$this->config->getAppValueString('node_binary', '""')" "'${nodejs}/bin/node'" \
      --replace-quiet "\$this->config->getAppValueString('node_binary')" "'${nodejs}/bin/node'" \
      --replace-quiet "\$this->config->getAppValue('node_binary', '""')" "'${nodejs}/bin/node'" \
      --replace-quiet "\$this->config->getAppValue('node_binary')" "'${nodejs}/bin/node'"
    test "$(grep "get[a-zA-Z]*('node_binary'" recognize/lib/**/*.php | wc -l)" -eq 0



    # Skip trying to install it... (less warnings in the log)
    sed  -i '/public function run/areturn ; //skip' recognize/lib/Migration/InstallDeps.php

    ln -s ${ffmpeg}/bin/ffmpeg recognize/node_modules/ffmpeg-static/ffmpeg
  '';

  nativeBuildInputs = lib.optionals useLibTensorflow [
    nodejs
    nodejs.pkgs.node-pre-gyp
    nodejs.pkgs.node-gyp
    python3
    util-linux
  ];

  buildPhase = lib.optionalString useLibTensorflow ''
    cd recognize

    # Install tfjs dependency
    export CPPFLAGS="-I${nodejs}/include/node -Ideps/include"
    cd node_modules/@tensorflow/tfjs-node
    node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs}/include/node
    cd -

    # Test tfjs returns exit code 0
    node src/test_libtensorflow.js
    cd ..
  '';
  installPhase = ''
    approot="$(dirname $(dirname $(find -path '*/appinfo/info.xml' | head -n 1)))"
    if [ -d "$approot" ];
    then
      mv "$approot/" $out
      chmod -R a-w $out
    fi
  '';

  meta = with lib; {
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ beardhatcode ];
    longDescription = ''
      Nextcloud app that does Smart media tagging and face recognition with on-premises machine learning models.
      This app goes through your media collection and adds fitting tags, automatically categorizing your photos and music.
    '';
    homepage = "https://apps.nextcloud.com/apps/recognize";
  };
}
