{ lib, stdenv, fetchurl, system ? builtins.currentSystem, ovftoolBundles ? {}
, requireFile, autoPatchelfHook, fixDarwinDylibNames, makeWrapper, unzip
, glibc, c-ares, libxcrypt, expat, icu60, xercesc, zlib
}:

let
  version = "4.5.0-20459872";

  ovftoolZipUnpackPhase = ''
    runHook preUnpack
    unzip ${ovftoolSource}
    dirs=(ovftool 'VMWare OVF Tool')
    found=""
    for dir in "''${dirs[@]}"; do
      if [ -d "$dir/" ]; then
        found="$dir"
        echo "ovftool extracted successfully" >&2
        break
      fi
    done

    if [ -z "$found" ]; then
      echo "Could not find the root extract directory - are you sure this is ovftool?" >&2
      exit 1
    fi

    if [ "$found" != ovftool ]; then
      # Make sure the root is just named 'ovftool' for the installPhase.
      mv "$found" ovftool
    fi

    if [ -d ovftool/lib ]; then
      # Libs are here on OS X.
      mv ovftool/lib/* ovftool/
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
    "x86_64-darwin" = rec {
      filename = "VMware-ovftool-${version}-mac.x64.zip";
      url = "${baseUrl}/d2a12d16-4a0d-4d1e-a460-36fd93268974/144ab954-cb82-4d9e-bd10-08af46debfd9/${filename}";
      sha256 = "0lfd3sr8mvfpf829bygmfmwldwp1pl8ds29z9g8wjqxkdlsfjvb2";
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
    libxcrypt
    c-ares
    expat
    icu60
    xercesc
    zlib
  ] ++ (lib.optional stdenv.isLinux glibc);

  nativeBuildInputs = [
    makeWrapper unzip
  ] ++ (lib.optional stdenv.isLinux autoPatchelfHook)
    ++ (lib.optional stdenv.isDarwin fixDarwinDylibNames);

  preferLocalBuild = true;

  sourceRoot = ".";

  unpackPhase = ovftoolSystem.unpackPhase;

  # Expects a directory named 'ovftool' or 'VMWare OVF Tool' containing the ovftool install.
  # Based on https://aur.archlinux.org/packages/vmware-ovftool/
  # with the addition of a libexec directory and a Nix-style binary wrapper.
  installPhase = ''
    runHook preInstall
    # Ensure we're in the staging directory
    if [ -d ovftool ]; then
      cd ovftool
    fi

    # libraries
    install -m 755 -d "$out/lib/${pname}"

    # Echoes a platform compatible dylib/.so name.
    nameOf() {
        local version="$2"
        if [ -n "$version" ]; then
            version=".$version"
        fi
        echo ${if stdenv.isDarwin then ''"lib$1$version"*".dylib"'' else ''"lib$1.so$version"*''}
    }

    # These all appear to be VMWare proprietary except for libgoogleurl and libcurl.
    # The rest of the libraries that the installer extracts are omitted here,
    # and provided in buildInputs. Since libcurl depends on VMWare's OpenSSL,
    # we have to use both here too.
    #
    # FIXME: can we replace libgoogleurl? Possibly from Chromium?
    # FIXME: tell VMware to use a modern version of OpenSSL.
    #
    install -m 644 -t "$out/lib/${pname}" \
      "$(nameOf googleurl 59)" \
      "$(nameOf ssoclient)" \
      "$(nameOf vim-types)" "$(nameOf vmacore)" "$(nameOf vmomi)" \
      "$(nameOf curl 4)" "$(nameOf crypto 1.0.2)" "$(nameOf ssl 1.0.2)"
    # libexec binaries
    install -m 755 -d "$out/libexec/${pname}"

    ovftool_bin=${if stdenv.isDarwin then "ovftool" else "ovftool.bin"}
    install -m 755 -t "$out/libexec/${pname}" $ovftool_bin
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
    makeWrapper "$out/libexec/${pname}/$ovftool_bin" "$out/bin/ovftool" \
      --set-default LC_CTYPE C.UTF-8 \
      --prefix ${if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH"} : ${if stdenv.isDarwin then "$out/lib/ovftool" else "$out/lib"}
    ${lib.optionalString stdenv.isDarwin ''fixDarwinDylibNames "$out/libexec/${pname}/$ovftool_bin"''}
    runHook postInstall
  '';

  preFixup = ''
    ${lib.optionalString stdenv.isLinux ''addAutoPatchelfSearchPath "$out/lib"''}
    ${lib.optionalString stdenv.isDarwin ''fixDarwinDylibNames "$out/lib/ovftool"/*.dylib''}
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
