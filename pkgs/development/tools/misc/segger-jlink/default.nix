{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, qt4
, udev
, system
, config
, acceptLicense ? config.segger-jlink.acceptLicense or false
}:

let
  supported = {
    x86_64-linux = {
      name = "x86_64";
      sha256 = "0cmd9ny6mslj9260scply573gbmn6k5r9wyxmcbjb14k4b3sldic";
    };
    i686-linux = {
      name = "i386";
      sha256 = "1jjh5a8y17ma369s9k0xlyr8i10v2r1kxmv0i9v4cix5dnjyq0pp";
    };
    aarch64-linux = {
      name = "arm64";
      sha256 = "0p3gjv36a82xyps20drm7h0vm0jmz5gd930ynwr3iy46md41hgyv";
    };
    armv7l-linux = {
      name = "arm";
      sha256 = "0z9q3mqhfwb341mk5p1d3vp6mfwffcdk68968jy1qr2ga2s34wpb";
    };
  };

  platform = supported.${system} or (throw "unsupported platform ${system}");

  version = "750";

  url = "https://www.segger.com/downloads/jlink/JLink_Linux_V${version}_${platform.name}.tgz";

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

in stdenv.mkDerivation {
  pname = "segger-jlink";
  inherit version;

  src = fetchurl {
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
    # Install all files to JLink first
    mkdir -p $out/JLink
    cp -r * $out/JLink

    # Symlink all binaries into bin
    mkdir -p $out/bin
    for prog in $out/JLink/J*; do
      if test -L $prog; then
        mv $prog $out/bin
      else
        ln -s $prog $out/bin
      fi
    done

    # Remove included Qt4
    rm $out/JLink/libQt*

    ${lib.optionalString (system == "x86_64-linux") ''
      # Remove 32-bit libs on 64-bit x86 systems
      rm -r $out/JLink/{x86,lib*_x86.so*}
    ''}

    ${lib.optionalString (system == "aarch64-linux") ''
      # Remove 32-bit libs on 64-bit ARM systems
      rm -r $out/JLink/{arm,lib*_arm.so*}
    ''}

    # Symlink all libraries into lib
    mkdir -p $out/lib
    ln -s $out/JLink/*.so* $out/lib

    # Move docs and examples
    mkdir -p $out/share
    mv $out/JLink/Doc $out/share/docs
    mv $out/JLink/Samples $out/share/examples

    # Move udev rule
    mkdir -p $out/lib/udev/rules.d
    mv $out/JLink/99-jlink.rules $out/lib/udev/rules.d/
  '';

  preFixup = ''
    # Workaround to setting runtime dependecy
    patchelf --add-needed libudev.so.1 $out/JLink/libjlinkarm.so
  '';

  meta = with lib; {
    description = "J-Link Software and Documentation pack";
    homepage = "https://www.segger.com/downloads/jlink/#J-LinkSoftwareAndDocumentationPack";
    license = licenses.unfree;
    platforms = attrNames supported;
    maintainers = with maintainers; [ FlorianFranzen reardencode ];
  };
}
