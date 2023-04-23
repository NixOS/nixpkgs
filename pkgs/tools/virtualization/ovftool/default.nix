{ lib, stdenv, fetchurl, system ? builtins.currentSystem, ovftoolBundles ? {}
, requireFile, autoPatchelfHook, makeWrapper, unzip
, glibc, c-ares, libxcrypt, expat, icu60, xercesc, zlib
}:

let
  version = "4.5.0-20459872";

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
      filename = "VMware-ovftool-${version}-lin.i386.zip";
      url = "${baseUrl}/b70b2ad5-861a-4c11-b081-e541586bf934/57109c63-6b80-4ced-95f2-1b7255200a36/${filename}";
      sha256 = "11zs5dm4gmssm94s501p66l4s8v9p7prrd87cfa903mwmyp0ihnx";
      unpackPhase = ovftoolZipUnpackPhase;
    };
    "x86_64-linux" = rec {
      filename = "VMware-ovftool-${version}-lin.x86_64.zip";
      url = "${baseUrl}/f87355ff-f7a9-4532-b312-0be218a92eac/b2916af6-9f4f-4112-adac-49d1d6c81f63/${filename}";
      sha256 = "1fkm18yfkkm92m7ccl6b4nxy5lagwwldq56b567091a5sgad38zw";
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
                      name = ovftoolSystem.filename;
                      url = ovftoolSystem.url;
                      sha256 = ovftoolSystem.sha256;
                    };
in
stdenv.mkDerivation rec {
  pname = "ovftool";
  inherit version;

  src = ovftoolSource;

  # Maintainers: try downloading a NixOS OVA and run the following to test:
  # `./result/bin/ovftool https://channels.nixos.org/nixos-unstable/latest-nixos-x86_64-linux.ova nixos.ovf`
  # Some dependencies are not loaded until operations actually occur!
  buildInputs = [
    glibc
    libxcrypt
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
  };
}
