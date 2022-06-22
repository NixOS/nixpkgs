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
      sha256 = "90aa7e4f5eae6e60fd41978111b3ff124ba0269562d0d0ec3110d3cb4bb51fe2";
    };
    i686-linux = {
      name = "i386";
      sha256 = "18aea42cd17591cada78af7cba0f94a9d851e9d29995b6c8e1e7033d0af35d1c";
    };
    aarch64-linux = {
      name = "arm64";
      sha256 = "db410c1df80748827b4e25ff3abceee29e28305a0a7e30e4e39bb5c7e32f1aa2";
    };
    armv7l-linux = {
      name = "arm";
      sha256 = "abcdaf44aeb2ad4e769709ec4fe971e259b23d297a98f58199c7bdf26db82e84";
    };
  };

  platform = supported.${system} or (throw "unsupported platform ${system}");

  version = "766";

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
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
