{ lib, stdenv, system ? builtins.currentSystem, ovftoolBundles ? {}
, requireFile, buildFHSUserEnv, autoPatchelfHook, makeWrapper, unzip
, glibc, c-ares, libressl, curl, expat, icu60, xercesc, zlib
}:

let
  version = "4.4.1-16812187";

  # FHS environment required to unpack ovftool on x86.
  ovftoolX86Unpacker = buildFHSUserEnv rec {
    name = "ovftool-unpacker";
    targetPkgs = pkgs: [ pkgs.bash ];
    multiPkgs = targetPkgs;
    runScript = "bash";
  };

  # unpackPhase for i686 and x86_64 ovftool self-extracting bundles.
  ovftoolX86UnpackPhase = ''
    runHook preUnpack
    # This is a self-extracting shell script and needs a FHS environment to run.
    # In reality, it could be doing anything, which is bad for reproducibility.
    # Our postUnpack uses nix-hash to verify the hash to prevent problems.
    #
    # Note that the Arch PKGBUILD at
    # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=vmware-ovftool
    # appears to use xvfb-run - this hasn't been proven necessary so far.
    #
    cp ${ovftoolSource} ./ovftool.bundle
    chmod +x ./ovftool.bundle
    ${ovftoolX86Unpacker}/bin/ovftool-unpacker ./ovftool.bundle -x ovftool
    rm ovftool.bundle
    extracted=ovftool/vmware-ovftool/
    if [ -d "$extracted" ]; then
      # Move the directory we care about to ovftool/
      mv "$extracted" .
      rm -r ovftool
      mv "$(basename -- "$extracted")" ovftool
      echo "ovftool extracted successfully" >&2
    else
      echo "Could not find $extracted - are you sure this is ovftool?" >&2
      rm -r ovftool
      exit 1
    fi
    runHook postUnpack
  '';

  # unpackPhase for aarch64 .zip.
  ovftoolAarch64UnpackPhase = ''
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

  # When the version is bumped, postUnpackHash will change
  # for all these supported systems. Update it from the printed error on build.
  #
  # This is just a sanity check, since ovftool is a self-extracting bundle
  # that could be doing absolutely anything on 2/3 of the supported platforms.
  ovftoolSystems = {
    "i686-linux" = {
      filename = "VMware-ovftool-${version}-lin.i386.bundle";
      sha256 = "0gx78g3s77mmpir7jbiskna10i6262ihal1ywivlb6xxxxbhqzwj";
      unpackPhase = ovftoolX86UnpackPhase;
      postUnpackHash = "1k8rp8ywhs0cl9aad37v1p0493bdvkxrsvwg5pgv2bhvjs4hqk7n";
    };
    "x86_64-linux" = {
      filename = "VMware-ovftool-${version}-lin.x86_64.bundle";
      sha256 = "1kp2bp4d9i8y7q25yqff2bn62mh292lws7b66lyn8ka9b35kvnzc";
      unpackPhase = ovftoolX86UnpackPhase;
      postUnpackHash = "0zvyakwi4iishqxxisihgh91bmdsfvj5vchm2c192hia03a143py";
    };
    "aarch64-linux" = {
      filename = "VMware-ovftool-${version}-lin.aarch64.zip";
      sha256 = "0all8bwv5p5adnzqvrly6nzmxmfpywvlbfr0finr4n100yv0v1xy";
      unpackPhase = ovftoolAarch64UnpackPhase;
      postUnpackHash = "16vyyzrmryi8b7mrd6nxnhywvvj2pw0ban4qfiqfahw763fn6971";
    };
  };

  ovftoolSystem = if builtins.hasAttr system ovftoolSystems then
                    ovftoolSystems.${system}
                  else throw "System '${system}' is unsupported by ovftool";

  ovftoolSource = if builtins.hasAttr system ovftoolBundles then
                    ovftoolBundles.${system}
                  else
                    requireFile {
                      name = ovftoolSystem.filename;
                      url = "https://my.vmware.com/group/vmware/downloads/get-download?downloadGroup=OVFTOOL441";
                      sha256 = ovftoolSystem.sha256;
                    };
in
stdenv.mkDerivation rec {
  pname = "ovftool";
  inherit version;

  src = ovftoolSource;

  buildInputs = [
    glibc
    libressl
    c-ares
    (curl.override { openssl = libressl; })
    expat
    icu60
    xercesc
    zlib
  ];

  nativeBuildInputs = [ autoPatchelfHook makeWrapper unzip ];

  sourceRoot = ".";

  unpackPhase = ovftoolSystem.unpackPhase;

  postUnpackHash = ovftoolSystem.postUnpackHash;

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
    # These all appear to be VMWare proprietary except for libgoogleurl.
    # The rest of the libraries that the installer extracts are omitted here,
    # and provided in buildInputs.
    #
    # FIXME: can we replace libgoogleurl? Possibly from Chromium?
    #
    install -m 644 -t "$out/lib/${pname}" \
      libgoogleurl.so.59 \
      libssoclient.so \
      libvim-types.so libvmacore.so libvmomi.so
    # ovftool specifically wants 1.0.2 but our libcrypto is named 1.0.0
    ln -s "${lib.getLib libressl}/lib/libcrypto.so" \
      "$out/lib/${pname}/libcrypto.so.1.0.2"
    ln -s "${lib.getLib libressl}/lib/libssl.so" \
      "$out/lib/${pname}/libssl.so.1.0.2"
    # libexec
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

  meta = with lib; {
    description = "VMWare tools for working with OVF, OVA, and VMX images";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ numinit wolfangaukang ];
    platforms = builtins.attrNames ovftoolSystems;
  };
}
