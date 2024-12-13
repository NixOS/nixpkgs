{
  stdenv,
  requireFile,
  lib,
}:

let
  requireXcode =
    version: sha256:
    let
      xip = "Xcode_" + version + ".xip";

      unxip =
        if stdenv.buildPlatform.isDarwin then
          ''
            open -W ${xip}
            rm -rf ${xip}
          ''
        else
          ''
            xar -xf ${xip}
            rm -rf ${xip}
            pbzx -n Content | cpio -i
            rm Content Metadata
            rcodesign verify Xcode.app/Contents/MacOS/Xcode
          '';

      app = requireFile rec {
        name = "Xcode.app";
        url = "https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_${version}/${xip}";
        hashMode = "recursive";
        inherit sha256;
        message = ''
          Unfortunately, we cannot download ${name} automatically.
          Please go to ${url}
          to download it yourself, and add it to the Nix store by running the following commands.
          Note: download (~ 5GB), extraction and storing of Xcode will take a while

          ${unxip}
          nix-store --add-fixed --recursive sha256 Xcode.app
          rm -rf Xcode.app
        '';
      };
      meta = with lib; {
        homepage = "https://developer.apple.com/downloads/";
        description = "Apple's XCode SDK";
        license = licenses.unfree;
        platforms = platforms.darwin ++ platforms.linux;
        sourceProvenance = [ sourceTypes.binaryNativeCode ];
      };

    in
    app.overrideAttrs (oldAttrs: oldAttrs // { inherit meta; });

in
lib.makeExtensible (self: {
  xcode_8_1 = requireXcode "8.1" "sha256-VuAovU/b4rcLh+xMtcsZmbTWwTk35VGfMSp+fqPbsqM=";
  xcode_8_2 = requireXcode "8.2" "sha256-ohqgGD7JEEmXEvmfn/N9Ga2lM8jNwhIuh+ky7PQPzY4=";
  xcode_9_1 = requireXcode "9.1" "sha256-LG7pVMh1rNh5uP/bASvV9sKvGDrSGWH90J4gzwcgYSk=";
  xcode_9_2 = requireXcode "9.2" "sha256-jMiG2G2zoGw4m00CjkGE+2cn0qeOdSUcXosZI2577q0=";
  xcode_9_3 = requireXcode "9.3" "sha256-XIQYjfDVSmrYbyolnZIUtmOMhj9uhyWIn0KncsiaqYo=";
  xcode_9_4 = requireXcode "9.4" "sha256-ZzE4F4UHVgKlJIn36kfs6Pba8iUAe6P/rh/VmxwLXwE=";
  xcode_9_4_1 = requireXcode "9.4.1" "sha256-fFGB/XMZJQ2u9qh+2LYBHFh6mj5lr6gMlSQwgyS8M3k=";
  xcode_10_1 = requireXcode "10.1" "sha256-u4Br3SsWbPCv6r4vGHFQUQmfPb9oUEmcdCFktMlbTes=";
  xcode_10_2 = requireXcode "10.2" "sha256-592xNBS3Obp/3sDROyI4SxPN77cKMk45Lnis/QJd/vc=";
  xcode_10_2_1 = requireXcode "10.2.1" "sha256-r65DbLDpiFJ78VH2hvfp7ZVpehoI44PSnaeDbElZTYc=";
  xcode_10_3 = requireXcode "10.3" "sha256-61lDed7/Wi6uVBaj6/fUELISvmH3j69dQE19Y91GwsQ=";
  xcode_11 = requireXcode "11" "sha256-EDM5tjuzGTzlVUg6MJKup/Q2OBrFXjzFdXSRO+eQA+Q=";
  xcode_11_1 = requireXcode "11.1" "sha256-gXGVkEG+dFEoDbRjtfyN8MeUcoA6hcfsUaVDKAn7T7A=";
  xcode_11_2 = requireXcode "11.2" "sha256-8qFEgRVhgOomSnJk23WaM/nACK9JFmiIICjUfT/Co9I=";
  xcode_11_3 = requireXcode "11.3" "sha256-6nPCY0rIU2c7nRYDXMWcDHrCm34eqZq6wx157mk3OxM=";
  xcode_11_3_1 = requireXcode "11.3.1" "sha256-BI8Olfqyxh51jyNpydiRkPwTQ4OK+ZpHUybPkCSL1tw=";
  xcode_11_4 = requireXcode "11.4" "sha256-x/sLazHPs4SoCPKJ0CgFbTEmxlzJeZ7HtinMlse6uRg=";
  xcode_11_5 = requireXcode "11.5" "sha256-fLqMcIOM6ZqacTBMF6N0swJzOmnt+FfYlDt8m/BXP7Y=";
  xcode_11_6 = requireXcode "11.6" "sha256-nVDsbD7pGCM2jgXzRtV+VIFc/klmX05W6x/eOAOHjvg=";
  xcode_11_7 = requireXcode "11.7" "sha256-stKqjXmERNQ4qF/73EE34oLtfF9+WZXK9BwXSVjLQhA=";
  xcode_12 = requireXcode "12" "sha256-H8Hcre9dB2v2VT8/SrEkU+RZ2rZRiM0JqMX6i4yoffA=";
  xcode_12_0_1 = requireXcode "12.0.1" "sha256-gK7PZ22aR3ow72pSjr7tUIOsgoAEUqcMZgNCEFVp29w=";
  xcode_12_1 = requireXcode "12.1" "sha256-l4+MW8IWMqR/9dxd9FVtfxJs3M/qtIcj6nyQ2cjxLfI=";
  xcode_12_2 = requireXcode "12.2" "sha256-G8jku/9WB8Q1zgKWGbSv06bSWE385sPlc7xnfonjIJ4=";
  xcode_12_3 = requireXcode "12.3" "sha256-CYU2fAeT+DWiK/mpRoGv57RjGfseL23BDU57SokPjk8=";
  xcode_12_4 = requireXcode "12.4" "sha256-Qw4j+XFry85/AviHQVhjjjKLAfmRNNwMGN5G8FheJwQ=";
  xcode_12_5 = requireXcode "12.5" "sha256-xiGffnV0P9Ojd6IrJSXILUX4oznPif7zm00WAksn3qU=";
  xcode_12_5_1 = requireXcode "12.5.1" "sha256-zL0kS86ZzBkIrKLPKvWguDvXj9Tqbr7uR/VZaT/uZ9A=";
  xcode_13 = requireXcode "13" "sha256-uTY6d5DBu4OOQLkxs3ExDfLXh50rE2LLlqtCbk3Qn6E=";
  xcode_13_1 = requireXcode "13.1" "sha256-vd+4eFVaAyvXsdaExcfbDZSXOwkpt+rEbkBYSMjdUEA=";
  xcode_13_2 = requireXcode "13.2" "sha256-guJXm/QnMfvUZwAcJwoy0QeO+DpDcUhs8AxVKvm9tYQ=";
  xcode_13_2_1 = requireXcode "13.2.1" "sha256-r832Uu+Q8utK4zN0CtwiMCvMYT5HstWInyq4cNIaZJM=";
  xcode_13_3 = requireXcode "13.3" "sha256-p2zaWMpmUeNHQtYOOaVdhCt3cgapvzL3l73/J+UwzCE=";
  xcode_13_3_1 = requireXcode "13.3.1" "sha256-j71vpJVJpyj/IOlL+4+5lYgOlhf/zn+7ExIHbxL51cQ=";
  xcode_13_4 = requireXcode "13.4" "sha256-IY1coss90GlBeJg/HQPMU8v2rOOxsqlY5q+2Qxe8nnY=";
  xcode_13_4_1 = requireXcode "13.4.1" "sha256-Jk8fLgvnODoIhuVJqfV0KrpBBL40fRrHJbFmm44NRKE=";
  xcode_14 = requireXcode "14" "sha256-E+wjPgQx/lbYAsauksdmGsygL5VPBA8R9pHB93eA7T0=";
  xcode_14_1 = requireXcode "14.1" "sha256-QJGAUVIhuDYyzDNttBPv5lIGOfvkYqdOFSUAr5tlkfs=";
  xcode_15 = requireXcode "15" "sha256-ffqISt2Ayccln5BArKIjSdzbEgoSoNwq8TPLGysAE0c=";
  xcode_15_0_1 = requireXcode "15.0.1" "sha256-ZJFCA2HUNmw8NxW3wyIyIsMr8k6z50BHqu9IE2VjuOg=";
  xcode_15_1 = requireXcode "15.1" "sha256-0djqoSamU87rCpjo50Un3cFg9wKf+pSczRko6uumGM0=";
  xcode_15_2 = requireXcode "15.2" "sha256-9B/4Tdyb3QGAzm579QGn5Iq/hA2hscD8OcoSJ5BFFXs=";
  xcode_15_3 = requireXcode "15.3" "sha256-FyVA8EEPCI12Z4sJ4RQRZlMMpFmi7S8VYLcyvad3swM=";
  xcode_15_4 = requireXcode "15.4" "sha256-yeo+sf6bBIJy9/1sQiMuPEMPniwGXMB6/FXXL0UrI5U=";
  xcode_16 = requireXcode "16" "sha256-i/MMcEi5wCpe5+nGo6gUTsFFCoorORydAn7D/GClEdo=";
  xcode_16_1 = requireXcode "16.1" "sha256-yYg6NRRnYM/5X3hhVMfcXcdoiOV36fIongJNQ5nviD8=";
  xcode =
    self."xcode_${
      lib.replaceStrings [ "." ] [ "_" ] (
        if (stdenv.targetPlatform ? xcodeVer) then stdenv.targetPlatform.xcodeVer else "12.3"
      )
    }";
})
