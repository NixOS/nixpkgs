{ lib, stdenv, fetchurl, system ? builtins.currentSystem, ovftoolBundles ? {}
, autoPatchelfHook, makeWrapper, unzip
, glibc, c-ares, libxcrypt-legacy, expat, icu60, xercesc, zlib
}:

let
  version = "4.6.2-22220919";
  version_i686 = "4.6.0-21452615";

  ovftoolZipUnpackPhase = ''
    runHook preUnpack
    unzip ${ovftoolSource}
    extracted=ovftool/
    if [ -d "$extracted" ]; then
      echo "ovftool extracted successfully" >&2
    else
      echo "Could not find $extracted - are you sure this is ovftool?" >&2
      exit 1
    fi
    runHook postUnpack
  '';

  ovftoolSystems = let
    baseUrl = "https://vdc-download.vmware.com/vmwb-repository/dcr-public";
  in {
    "i686-linux" = rec {
      name = "VMware-ovftool-${version_i686}-lin.i386.zip";
      url = "${baseUrl}/7254abb2-434d-4f5d-83e2-9311ced9752e/57e666a2-874c-48fe-b1d2-4b6381f7fe97/${name}";
      hash = "sha256-qEOr/3SW643G5ZQQNJTelZbUxB8HmxPd5uD+Gqsoxz0=";
      unpackPhase = ovftoolZipUnpackPhase;
    };
    "x86_64-linux" = rec {
      name = "VMware-ovftool-${version}-lin.x86_64.zip";
      url = "${baseUrl}/8a93ce23-4f88-4ae8-b067-ae174291e98f/c609234d-59f2-4758-a113-0ec5bbe4b120/${name}";
      hash = "sha256-3B1cUDldoTqLsbSARj2abM65nv+Ot0z/Fa35/klJXEY=";
      unpackPhase = ovftoolZipUnpackPhase;
    };
  };

  ovftoolSystem = if builtins.hasAttr system ovftoolSystems then
                    ovftoolSystems.${system}
                  else throw "System '${system}' is unsupported by ovftool";

  ovftoolSource = if builtins.hasAttr system ovftoolBundles then
                    ovftoolBundles.${system}
                  else
                    fetchurl {
                      inherit (ovftoolSystem) name url hash;
                    };
in
stdenv.mkDerivation rec {
  pname = "ovftool";
  inherit version;

  src = ovftoolSource;

  buildInputs = [
    glibc
    libxcrypt-legacy
    c-ares
    expat
    icu60
    xercesc
    zlib
  ];

  nativeBuildInputs = [ autoPatchelfHook makeWrapper unzip ];

  preferLocalBuild = true;

  sourceRoot = ".";

  unpackPhase = ovftoolSystem.unpackPhase;

  # Expects a directory named 'ovftool' containing the ovftool install.
  # Based on https://aur.archlinux.org/packages/vmware-ovftool/
  # with the addition of a libexec directory and a Nix-style binary wrapper.
  installPhase = ''
    runHook preInstall
    if [ -d ovftool ]; then
      # Ensure we're in the staging directory
      cd ovftool
    fi
    # libraries
    install -m 755 -d "$out/lib/${pname}"
    # These all appear to be VMWare proprietary except for libgoogleurl and libcurl.
    # The rest of the libraries that the installer extracts are omitted here,
    # and provided in buildInputs. Since libcurl depends on VMWare's OpenSSL,
    # we have to use both here too.
    #
    # FIXME: can we replace libgoogleurl? Possibly from Chromium?
    # FIXME: tell VMware to use a modern version of OpenSSL.
    #
    install -m 644 -t "$out/lib/${pname}" \
      libgoogleurl.so.59 \
      libssoclient.so \
      libvim-types.so libvmacore.so libvmomi.so \
      libcurl.so.4 libcrypto.so.1.0.2 libssl.so.1.0.2
    # libexec binaries
    install -m 755 -d "$out/libexec/${pname}"
    install -m 755 -t "$out/libexec/${pname}" ovftool.bin
    install -m 644 -t "$out/libexec/${pname}" icudt44l.dat
    # libexec resources
    for subdir in "certs" "env" "env/en" "schemas/DMTF" "schemas/vmware"; do
      install -m 755 -d "$out/libexec/${pname}/$subdir"
      install -m 644 -t "$out/libexec/${pname}/$subdir" "$subdir"/*.*
    done
    # EULA/OSS files
    install -m 755 -d "$out/share/licenses/${pname}"
    install -m 644 -t "$out/share/licenses/${pname}" \
      "vmware.eula" "vmware-eula.rtf" "open_source_licenses.txt"
    # documentation files
    install -m 755 -d "$out/share/doc/${pname}"
    install -m 644 -t "$out/share/doc/${pname}" "README.txt"
    # binary wrapper; note that LC_CTYPE is defaulted to en_US.UTF-8 by
    # VMWare's wrapper script. We use C.UTF-8 instead.
    install -m 755 -d "$out/bin"
    makeWrapper "$out/libexec/${pname}/ovftool.bin" "$out/bin/ovftool" \
      --set-default LC_CTYPE C.UTF-8 \
      --prefix LD_LIBRARY_PATH : "$out/lib"
    runHook postInstall
  '';

  preFixup = ''
    addAutoPatchelfSearchPath "$out/lib"
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    # This is a NixOS 22.11 image (doesn't actually matter) with a 1 MiB root disk that's all zero.
    # Make sure that it converts properly.
    mkdir -p ovftool-check
    cd ovftool-check

    $out/bin/ovftool ${./installCheckPhase.ova} nixos.ovf
    if [ ! -f nixos.ovf ] || [ ! -f nixos.mf ] || [ ! -f nixos-disk1.vmdk ]; then
      exit 1
    fi
  '';

  meta = with lib; {
    description = "VMWare tools for working with OVF, OVA, and VMX images";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ numinit wolfangaukang ];
    platforms = builtins.attrNames ovftoolSystems;
    mainProgram = "ovftool";
  };
}
