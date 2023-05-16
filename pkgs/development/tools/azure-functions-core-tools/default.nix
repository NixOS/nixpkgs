{
  stdenv,
  lib,
  config,
  fetchurl,
  unzip,
  makeWrapper,
  icu,
  libunwind,
  curl,
  zlib,
  libuuid,
  dotnetbuildhelpers,
  dotnetCorePackages,
  openssl,
}: let
  platforms = {
    "aarch64-darwin" = {
      platformStr = "osx-arm64";
<<<<<<< HEAD
      hash = "sha512-Jpj/jmDoc01f1LqcdtszZHOG87jy7p3INajhN0taVzVX6l7WnrxY9Y8VLffBffWuNJ9LZjpGVDLt4/JqyALWrw==";
    };
    "x86_64-darwin" = {
      platformStr = "osx-x64";
      hash = "sha512-mHOEnSxcA3x2LK3rhte5eMP97mf0q8BkbS54gGFGz91ufigWmTRrSlGVr3An/1iLlA5/k+AHJU4olWbL2Qlr0A==";
    };
    "x86_64-linux" = {
      platformStr = "linux-x64";
      hash = "sha512-d2Ym8kofv/ik4m94D0gz3LcOQxWIDaGmXTmv4XX2zYztH/4wXC2JRr8vIpqwwX86gy3apUmTc3rCyc5Zrz2Sig==";
=======
      hash = "sha512-MDuyFxtjlojXyrOdgJxVY3IDMLnrDvA4rO7ujOlE5KH082GXfonNOFZSpa64M8jMPJhJ4sopHKgZVvKKygzjPg==";
    };
    "x86_64-darwin" = {
      platformStr = "osx-x64";
      hash = "sha512-fD48QFYIzq3/EvZR3o3VFCxIz3VZGSDJUo/ZwfZnFu7xt/xkQSBL+2zXOh9XZaBg42Xq3x9eFZQ00V8AbqJdKA==";
    };
    "x86_64-linux" = {
      platformStr = "linux-x64";
      hash = "sha512-PhgS2ivRn8Yhlr7+gbQd+rGSMDLGsxURh8lOE30Xk7zEubukjekxDsaPqM1tOS95k7TWM9xXyVVfmsJplrl+nw==";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  platformInfo = builtins.getAttr stdenv.targetPlatform.system platforms;
in
  stdenv.mkDerivation rec {
    pname = "azure-functions-core-tools";
<<<<<<< HEAD
    version = "4.0.5095";
=======
    version = "4.0.4915";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    src = fetchurl {
      url = "https://github.com/Azure/${pname}/releases/download/${version}/Azure.Functions.Cli.${platformInfo.platformStr}.${version}.zip";
      inherit (platformInfo) hash;
    };

    nativeBuildInputs = [
      unzip
      makeWrapper
      dotnetbuildhelpers
      icu
      libunwind
      curl
      zlib
      dotnetCorePackages.sdk_6_0
    ];

    libPath = lib.makeLibraryPath [
      libunwind
      libuuid
      stdenv.cc.cc
      curl
      zlib
      icu
      openssl
    ];

    unpackPhase = ''
      unzip $src
    '';

    installPhase =
      ''
        mkdir -p $out/bin
        cp -prd . $out/bin/azure-functions-core-tools
        chmod +x $out/bin/azure-functions-core-tools/{func,gozip}
      ''
      + lib.optionalString stdenv.isLinux ''
        patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "${libPath}" "$out/bin/azure-functions-core-tools/func"
        find $out/bin/azure-functions-core-tools -type f -name "*.so" -exec patchelf --set-rpath "${libPath}" {} \;
        wrapProgram "$out/bin/azure-functions-core-tools/func" --prefix LD_LIBRARY_PATH : ${libPath}
      ''
      + ''
        ln -s $out/bin/{azure-functions-core-tools,}/func
        ln -s $out/bin/{azure-functions-core-tools,}/gozip
      '';
    dontStrip = true; # Causes rpath patching to break if not set

    meta = with lib; {
      homepage = "https://github.com/Azure/azure-functions-core-tools";
      description = "Command line tools for Azure Functions";
      sourceProvenance = with sourceTypes; [
        binaryBytecode
        binaryNativeCode
      ];
      license = licenses.mit;
      maintainers = with maintainers; [];
      platforms = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"];
    };
  }
