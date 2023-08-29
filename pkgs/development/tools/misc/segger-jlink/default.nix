{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, qt4
, udev
, config
, acceptLicense ? config.segger-jlink.acceptLicense or false
}:

let
  supported = {
    x86_64-linux = {
      name = "x86_64";
      sha256 = "sha256-7+85/uiOyKKwmV2jZQsUy/RASa5AOHqLyW2Azbkg6DY=";
    };
    i686-linux = {
      name = "i386";
      sha256 = "sha256-o6deenN4UbzsXx7lMqWGHpqVeik4dZBDnjxKZUBDIKY=";
    };
    aarch64-linux = {
      name = "arm64";
      sha256 = "sha256-mo1J+cW1GBi7Hkh5Idm6cSA+kEsDZ3BQyURiEnFtTcU=";
    };
    armv7l-linux = {
      name = "arm";
      sha256 = "sha256-XAA1WECrzrRYRZrF7DGE7LzIWP6BS1J2qyYoJJnAVkA=";
    };
  };

  platform = supported.${stdenv.system} or (throw "unsupported platform ${stdenv.system}");

  version = "792b";

  url = "https://www.segger.com/downloads/jlink/JLink_Linux_V${version}_${platform.name}.tgz";

in stdenv.mkDerivation {
  pname = "segger-jlink";
  inherit version;

  src =
    assert !acceptLicense -> throw ''
      Use of the "SEGGER JLink Software and Documentation pack" requires the
      acceptance of the following licenses:

        - SEGGER Downloads Terms of Use [1]
        - SEGGER Software Licensing [2]

      You can express acceptance by setting acceptLicense to true in your
      configuration. Note that this is not a free license so it requires allowing
      unfree licenses as well.

      configuration.nix:
        nixpkgs.config.allowUnfree = true;
        nixpkgs.config.segger-jlink.acceptLicense = true;

      config.nix:
        allowUnfree = true;
        segger-jlink.acceptLicense = true;

      [1]: ${url}
      [2]: https://www.segger.com/purchase/licensing/
    '';
      fetchurl {
        inherit url;
        inherit (platform) sha256;
        curlOpts = "--data accept_license_agreement=accepted";
      };

  # Currently blocked by patchelf bug
  # https://github.com/NixOS/patchelf/pull/275
  #runtimeDependencies = [ udev ];

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ qt4 udev ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Install binaries
    mkdir -p $out/bin
    mv J* $out/bin

    # Install libraries
    mkdir -p $out/lib
    mv libjlinkarm.so* $out/lib
    # This library is opened via dlopen at runtime
    for libr in $out/lib/*; do
      ln -s $libr $out/bin
    done

    # Install docs and examples
    mkdir -p $out/share/docs
    mv Doc/* $out/share/docs
    mkdir -p $out/share/examples
    mv Samples/* $out/share/examples

    # Install udev rule
    mkdir -p $out/lib/udev/rules.d
    mv 99-jlink.rules $out/lib/udev/rules.d/

    runHook postInstall
  '';

  preFixup = ''
    # Workaround to setting runtime dependecy
    patchelf --add-needed libudev.so.1 $out/lib/libjlinkarm.so
  '';

  meta = with lib; {
    description = "J-Link Software and Documentation pack";
    homepage = "https://www.segger.com/downloads/jlink/#J-LinkSoftwareAndDocumentationPack";
    license = licenses.unfree;
    platforms = attrNames supported;
    maintainers = with maintainers; [ FlorianFranzen stargate01 ];
  };
}
