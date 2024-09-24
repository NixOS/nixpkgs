{ autoPatchelfHook
, c-ares
, darwin
, expat
, fetchurl
, glibc
, icu60
, lib
, libiconv
, libredirect
, libxcrypt-legacy
, libxml2
, makeWrapper
, stdenv
, unzip
, xercesc
, zlib
}:

let

  ovftoolSystems =
    let
      baseUrl = "https://vdc-download.vmware.com/vmwb-repository/dcr-public";
    in
    {
      "i686-linux" = rec {
        name = "VMware-ovftool-${version}-lin.i386.zip";
        # As of 2024-02-20 the "Zip of OVF Tool for 32-bit Linux" download link
        # on the v4.6.2 page links to v4.6.0.
        version = "4.6.0-21452615";
        url = "${baseUrl}/7254abb2-434d-4f5d-83e2-9311ced9752e/57e666a2-874c-48fe-b1d2-4b6381f7fe97/${name}";
        hash = "sha256-qEOr/3SW643G5ZQQNJTelZbUxB8HmxPd5uD+Gqsoxz0=";
      };
      "x86_64-linux" = rec {
        name = "VMware-ovftool-${version}-lin.x86_64.zip";
        version = "4.6.2-22220919";
        url = "${baseUrl}/8a93ce23-4f88-4ae8-b067-ae174291e98f/c609234d-59f2-4758-a113-0ec5bbe4b120/${name}";
        hash = "sha256-3B1cUDldoTqLsbSARj2abM65nv+Ot0z/Fa35/klJXEY=";
      };
      "x86_64-darwin" = rec {
        name = "VMware-ovftool-${version}-mac.x64.zip";
        version = "4.6.2-22220919";
        url = "${baseUrl}/91091b23-280a-487a-a048-0c2594303c92/dc666e23-104f-4b9b-be11-6d88dcf3ab98/${name}";
        hash = "sha256-AZufZ0wxt5DYjnpahDfy36W8i7kjIfEkW6MoELSx11k=";
      };
    };

  ovftoolSystem = ovftoolSystems.${stdenv.system} or (throw "unsupported system ${stdenv.system}");

in
stdenv.mkDerivation {
  pname = "ovftool";
  inherit (ovftoolSystem) version;

  src = fetchurl {
    inherit (ovftoolSystem) name url hash;
  };

  buildInputs = [
    c-ares
    expat
    icu60
    libiconv
    libxcrypt-legacy
    xercesc
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    glibc
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.Libsystem
    libxml2
  ];

  nativeBuildInputs = [ unzip makeWrapper ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  postUnpack = ''
    # The linux package wraps ovftool.bin with ovftool. Wrapping
    # below in installPhase.
    # Rename to ovftool on install for all systems to ovftool
    if [[ -f ovftool.bin ]]; then
      mv -v ovftool.bin ovftool
    fi
  '';

  installPhase = ''
    runHook preInstall

    # Based on https://aur.archlinux.org/packages/vmware-ovftool/
    # with the addition of a libexec directory and a Nix-style binary wrapper.

    # Almost all libs in the package appear to be VMware proprietary except for
    # libgoogleurl and libcurl. The rest of the libraries that the installer
    # extracts are omitted here, and provided in buildInputs. Since libcurl
    # depends on VMware's OpenSSL, both libs are still used.
    # FIXME: Replace libgoogleurl? Possibly from Chromium?
    # FIXME: Tell VMware to use a modern version of OpenSSL. As of ovftool
    # v4.6.2 ovftool uses openssl-1.0.2zh which in seems to be the extended
    # support LTS release: https://www.openssl.org/support/contracts.html

    # Install all libs that are not patched in preFixup.
    # Darwin dylibs are under `lib` in the zip.
    install -m 755 -d "$out/lib"
    install -m 644 -t "$out/lib" \
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
      libcrypto.so.1.0.2 \
      libcurl.so.4 \
      libgoogleurl.so.59 \
      libssl.so.1.0.2 \
      libssoclient.so \
      libvim-types.so \
      libvmacore.so \
      libvmomi.so
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
      lib/libcrypto.1.0.2.dylib \
      lib/libcurl.4.dylib \
      lib/libgoogleurl.59.0.30.45.2.dylib \
      lib/libssl.1.0.2.dylib \
      lib/libssoclient.dylib \
      lib/libvim-types.dylib \
      lib/libvmacore.dylib \
      lib/libvmomi.dylib
    '' + ''
    # Install libexec binaries
    # ovftool expects to be run relative to certain directories, namely `env`.
    # Place the binary and those dirs in libexec.
    install -m 755 -d "$out/libexec"
    install -m 755 -t "$out/libexec" ovftool
    [ -f ovftool.bin ] && install -m 755 -t "$out/libexec" ovftool.bin
    install -m 644 -t "$out/libexec" icudt44l.dat

    # Install other libexec resources that need to be relative to the `ovftool`
    # binary.
    for subdir in "certs" "env" "env/en" "schemas/DMTF" "schemas/vmware"; do
      install -m 755 -d "$out/libexec/$subdir"
      install -m 644 -t "$out/libexec/$subdir" "$subdir"/*.*
    done

    # Install EULA/OSS files
    install -m 755 -d "$out/share/licenses"
    install -m 644 -t "$out/share/licenses" \
      "vmware.eula" \
      "vmware-eula.rtf" \
      "open_source_licenses.txt"

    # Install Docs
    install -m 755 -d "$out/share/doc"
    install -m 644 -t "$out/share/doc" "README.txt"

    # Install final executable
    install -m 755 -d "$out/bin"
    makeWrapper "$out/libexec/ovftool" "$out/bin/ovftool" \
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
      --prefix LD_LIBRARY_PATH : "$out/lib"
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
      --prefix DYLD_LIBRARY_PATH : "$out/lib"
  '' + ''
    runHook postInstall
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    addAutoPatchelfSearchPath "$out/lib"
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    change_args=()

    # Change relative @loader_path dylibs to absolute paths.
    for lib in $out/lib/*.dylib; do
      libname=$(basename $lib)
      change_args+=(-change "@loader_path/lib/$libname" "$out/lib/$libname")
    done

    # Patches for ovftool binary
    change_args+=(-change /usr/lib/libSystem.B.dylib ${darwin.Libsystem}/lib/libSystem.B.dylib)
    change_args+=(-change /usr/lib/libc++.1.dylib ${stdenv.cc.libcxx}/lib/libc++.1.dylib)
    change_args+=(-change /usr/lib/libiconv.2.dylib ${libiconv}/lib/libiconv.2.dylib)
    change_args+=(-change /usr/lib/libxml2.2.dylib ${libxml2}/lib/libxml2.2.dylib)
    change_args+=(-change /usr/lib/libz.1.dylib ${zlib}/lib/libz.1.dylib)
    change_args+=(-change @loader_path/lib/libcares.2.dylib ${c-ares}/lib/libcares.2.dylib)
    change_args+=(-change @loader_path/lib/libexpat.dylib ${expat}/lib/libexpat.dylib)
    change_args+=(-change @loader_path/lib/libicudata.60.2.dylib ${icu60}/lib/libicudata.60.2.dylib)
    change_args+=(-change @loader_path/lib/libicuuc.60.2.dylib ${icu60}/lib/libicuuc.60.2.dylib)
    change_args+=(-change @loader_path/lib/libxerces-c-3.2.dylib ${xercesc}/lib/libxerces-c-3.2.dylib)

    # Patch binary
    install_name_tool "''${change_args[@]}" "$out/libexec/ovftool"

    # Additional patches for ovftool dylibs
    change_args+=(-change /usr/lib/libresolv.9.dylib ${darwin.Libsystem}/lib/libresolv.9.dylib)
    change_args+=(-change @loader_path/libcares.2.dylib ${c-ares}/lib/libcares.2.dylib)
    change_args+=(-change @loader_path/libexpat.dylib ${expat}/lib/libexpat.dylib)
    change_args+=(-change @loader_path/libicudata.60.2.dylib ${icu60}/lib/libicudata.60.2.dylib)
    change_args+=(-change @loader_path/libicuuc.60.2.dylib ${icu60}/lib/libicuuc.60.2.dylib)
    change_args+=(-change @loader_path/libxerces-c-3.2.dylib ${xercesc}/lib/libxerces-c-3.2.dylib)

    # Add new abolute paths for other libs to all libs
    for lib in $out/lib/*.dylib; do
      libname=$(basename $lib)
      change_args+=(-change "@loader_path/$libname" "$out/lib/$libname")
    done

    # Patch all libs
    for lib in $out/lib/*.dylib; do
      libname=$(basename $lib)
      install_name_tool -id "$libname" "$lib"
      install_name_tool "''${change_args[@]}" "$lib"
    done
  '';

  # These paths are need for install check tests
  propagatedSandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
    (allow file-read* (subpath "/usr/share/locale"))
    (allow file-read* (subpath "/var/db/timezone"))
    (allow file-read* (subpath "/System/Library/TextEncodings"))
  '';

  doInstallCheck = true;

  postInstallCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export HOME=$TMPDIR
    # Construct a dummy /etc/passwd file - ovftool attempts to determine the
    # user's "real" home using this
    DUMMY_PASSWD="$(realpath $HOME/dummy-passwd)"
    cat > $DUMMY_PASSWD <<EOF
    $(whoami)::$(id -u):$(id -g)::$HOME:$SHELL
    EOF
    export DYLD_INSERT_LIBRARIES="${libredirect}/lib/libredirect.dylib"
    export NIX_REDIRECTS="/etc/passwd=$DUMMY_PASSWD"
  '' + ''
    mkdir -p ovftool-check && cd ovftool-check

    ovftool_with_args="$out/bin/ovftool --X:logToConsole"

    # `installCheckPhase.ova` is a NixOS 22.11 image (doesn't actually matter)
    # with a 1 MiB root disk that's all zero. Make sure that it converts
    # properly.

    $ovftool_with_args --schemaValidate ${./installCheckPhase.ova}
    $ovftool_with_args --sourceType=OVA --targetType=OVF ${./installCheckPhase.ova} nixos.ovf

    # Test that the output files are there
    test -f nixos.ovf
    test -f nixos.mf
    test -f nixos-disk1.vmdk

    $ovftool_with_args --schemaValidate nixos.ovf
  '';

  meta = with lib; {
    description = "VMware tools for working with OVF, OVA, and VMX images";
    homepage = "https://developer.vmware.com/web/tool/ovf-tool/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ numinit thanegill ];
    platforms = builtins.attrNames ovftoolSystems;
    mainProgram = "ovftool";
    knownVulnerabilities = [
      "The bundled version of openssl 1.0.2zh in ovftool has open vulnerabilities."
      "CVE-2024-0727"
      "CVE-2023-5678"
      "CVE-2023-3817"
      "CVE-2009-3767"
      "CVE-2009-3766"
      "CVE-2009-3765"
      "CVE-2009-1390"
    ];
  };
}
