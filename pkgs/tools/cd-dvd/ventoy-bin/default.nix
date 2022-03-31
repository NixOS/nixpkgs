{ lib, stdenv, fetchurl, fetchpatch
, autoPatchelfHook, makeWrapper
, bash, coreutils, dosfstools, exfat, gawk, gnugrep, gnused, hexdump, parted
, procps, util-linux, which, xz
, withCryptsetup ? false, cryptsetup
, withXfs ? false, xfsprogs
, withExt4 ? false, e2fsprogs
, withNtfs ? false, ntfs3g
, withGtk3 ? false, gtk3
, withQt5 ? false, qt5
, defaultGuiType ? ""
}:

assert lib.elem defaultGuiType ["" "gtk3" "qt5"];
assert defaultGuiType == "gtk3" -> withGtk3;
assert defaultGuiType == "qt5" -> withQt5;

let
  arch = {
    x86_64-linux = "x86_64";
    i686-linux = "i386";
    aarch64-linux = "aarch64";
    mipsel-linux = "mips64el";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}");
in stdenv.mkDerivation rec {
  pname = "ventoy-bin";
  version = "1.0.72";

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ]
    ++ lib.optional withQt5 qt5.wrapQtAppsHook;
  buildInputs = [
    bash coreutils dosfstools exfat gawk gnugrep gnused hexdump parted procps
    util-linux which xz
  ] ++ lib.optional withCryptsetup cryptsetup
    ++ lib.optional withXfs xfsprogs
    ++ lib.optional withExt4 e2fsprogs
    ++ lib.optional withNtfs ntfs3g
    ++ lib.optional withGtk3 gtk3
    ++ lib.optional withQt5 qt5.qtbase;

  src = fetchurl {
    url = "https://github.com/ventoy/Ventoy/releases/download/v${version}/ventoy-${version}-linux.tar.gz";
    sha256 = "sha256-1mfe6ZnqkeBNGNjI7Qx7jG5FLgfn6rVwr0VQvSOG7Ow=";
  };
  patches = [
    (fetchpatch {
      name = "sanitize.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/sanitize.patch?h=19f8922b3d96c5ff55eeefc269ae43369a0748e8";
      sha256 = "sha256-RDdxPCmrfNMwXNuJwQW48fAiJPbMjdHiBmF03fKqm2o=";
    })
    ./fix-for-read-only-file-system.patch
    ./add-mips64.patch
  ];
  patchFlags = [ "-p0" ];
  postPatch = ''
    # Fix permissions.
    find -type f -name \*.sh -exec chmod a+x '{}' \;

    # Fix path to log.
    sed -i 's:log\.txt:/var/log/ventoy\.log:g' \
        WebUI/static/js/languages.js tool/languages.json
  '';
  installPhase = ''
    # Setup variables.
    local VENTOY_PATH="$out"/share/ventoy
    local ARCH='${arch}'

    # Prepare.
    cd tool/"$ARCH"
    rm ash* hexdump* mkexfatfs* mount.exfat-fuse* xzcat*
    for archive in *.xz; do
        xzcat "$archive" > "''${archive%.xz}"
        rm "$archive"
    done
    chmod a+x *
    cd -

    # Cleanup.
    case "$ARCH" in
        x86_64) rm -r {tool/,VentoyGUI.}{i386,aarch64,mips64el};;
        i386) rm -r {tool/,VentoyGUI.}{x86_64,aarch64,mips64el};;
        aarch64) rm -r {tool/,VentoyGUI.}{x86_64,i386,mips64el};;
        mips64el) rm -r {tool/,VentoyGUI.}{x86_64,i386,aarch64};;
    esac
    rm README tool/VentoyWorker.sh.orig
    rm tool/"$ARCH"/Ventoy2Disk.gtk2 || true  # For aarch64 and mips64el.

    # Copy from "$src" to "$out".
    mkdir -p "$out"/bin "$VENTOY_PATH"
    cp -r . "$VENTOY_PATH"

    # Fill bin dir.
    for f in Ventoy2Disk.sh_ventoy VentoyWeb.sh_ventoy-web \
             CreatePersistentImg.sh_ventoy-persistent \
             ExtendPersistentImg.sh_ventoy-extend-persistent \
             VentoyPlugson.sh_ventoy-plugson; do
        local bin="''${f%_*}" wrapper="''${f#*_}"
        makeWrapper "$VENTOY_PATH/$bin" "$out/bin/$wrapper" \
                    --prefix PATH : "${lib.makeBinPath buildInputs}" \
                    --run "cd '$VENTOY_PATH' || exit 1"
    done
  '' + lib.optionalString (withGtk3 || withQt5) ''
    # VentoGUI uses the `ventoy_gui_type` file to determine the type of GUI.
    # See <https://github.com/ventoy/Ventoy/blob/471432fc50ffad80bde5de0b22e4c30fa3aac41b/LinuxGUI/Ventoy2Disk/ventoy_gui.c#L1044>.
    echo "${defaultGuiType}" > "$VENTOY_PATH/ventoy_gui_type"
    makeWrapper "$VENTOY_PATH/VentoyGUI.$ARCH" "$out/bin/ventoy-gui" \
                --prefix PATH : "${lib.makeBinPath buildInputs}" \
                --run "cd '$VENTOY_PATH' || exit 1"
  '' + lib.optionalString (!withGtk3) ''
    rm "$VENTOY_PATH/tool/$ARCH/Ventoy2Disk.gtk3"
  '' + lib.optionalString (!withQt5) ''
    rm "$VENTOY_PATH/tool/$ARCH/Ventoy2Disk.qt5"
  '';

  meta = with lib; {
    description = "An open source tool to create bootable USB drive for ISO/WIM/IMG/VHD(x)/EFI files";
    longDescription = ''
      An open source tool to create bootable USB drive for
      ISO/WIM/IMG/VHD(x)/EFI files.  With ventoy, you don't need to format the
      disk over and over, you just need to copy the ISO/WIM/IMG/VHD(x)/EFI
      files to the USB drive and boot them directly.  You can copy many files
      at a time and ventoy will give you a boot menu to select them.  You can
      also browse ISO/WIM/IMG/VHD(x)/EFI files in local disk and boot them.
      x86 Legacy BIOS, IA32 UEFI, x86_64 UEFI, ARM64 UEFI and MIPS64EL UEFI are
      supported in the same way.  Most type of OS supported
      (Windows/WinPE/Linux/ChromeOS/Unix/VMware/Xen...).  With ventoy you can
      also browse ISO/WIM/IMG/VHD(x)/EFI files in local disk and boot them.
      800+ image files are tested.  90%+ distros in <distrowatch.com>
      supported.
    '';
    homepage = "https://www.ventoy.net";
    changelog = "https://www.ventoy.net/doc_news.html";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" "mipsel-linux" ];
    maintainers = with maintainers; [ k4leg ];
  };
}
