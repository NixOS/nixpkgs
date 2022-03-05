{ lib, stdenv, fetchurl, fetchpatch
, autoPatchelfHook, makeWrapper
, hexdump, exfat, dosfstools, e2fsprogs, xz, util-linux, bash, parted
, withGtk3 ? true, gtk3
, withQt5 ? false, qt5
}:

let arch = {
  x86_64-linux = "x86_64";
  i686-linux = "i386";
  aarch64-linux = "aarch64";
  mipsel-linux = "mips64el";
}.${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}");
defaultGuiType = if withGtk3 then "gtk3"
                 else if withQt5 then "qt5"
                 else "";
in stdenv.mkDerivation rec {
  pname = "ventoy-bin";
  version = "1.0.56";

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ]
    ++ lib.optional withQt5 qt5.wrapQtAppsHook;
  buildInputs = [ hexdump exfat dosfstools e2fsprogs xz util-linux bash parted ]
    ++ lib.optional withGtk3 gtk3
    ++ lib.optional withQt5 qt5.qtbase;

  src = fetchurl {
    url = "https://github.com/ventoy/Ventoy/releases/download/v${version}/ventoy-${version}-linux.tar.gz";
    sha256 = "da53d51e653092a170c11dd560e0ad6fb27c497dd77ad0ba483c32935c069dea";
  };
  patches = [
    (fetchpatch {
      name = "sanitize.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/sanitize.patch?h=ventoy-bin&id=ce4c26c67a1de4b761f9448bf92e94ffae1c8148";
      sha256 = "c00f9f9cd5b4f81c566267b7b2480fa94d28dda43a71b1e47d6fa86f764e7038";
    })
    ./fix-for-read-only-file-system.patch
  ];
  patchFlags = [ "-p0" ];
  postPatch = ''
    # Fix permissions.
    find -type f -name \*.sh -exec chmod a+x '{}' \;

    # Fix path to log.
    sed -i 's:[lL]og\.txt:/var/log/ventoy\.log:g' WebUI/static/js/languages.js
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
    rm README
    rm tool/"$ARCH"/Ventoy2Disk.gtk2

    # Copy from "$src" to "$out".
    mkdir -p "$out"/bin "$VENTOY_PATH"
    cp -r . "$VENTOY_PATH"

    # Fill bin dir.
    for f in Ventoy2Disk.sh_ventoy VentoyWeb.sh_ventoy-web \
             CreatePersistentImg.sh_ventoy-persistent \
             ExtendPersistentImg.sh_ventoy-extend-persistent; do
        makeWrapper "$VENTOY_PATH/''${f%_*}" "$out/bin/''${f#*_}" \
                    --prefix PATH : "${lib.makeBinPath buildInputs}" \
                    --run "cd '$VENTOY_PATH' || exit 1"
    done
  '' + lib.optionalString (withGtk3 || withQt5) ''
    echo "${defaultGuiType}" > "$VENTOY_PATH/ventoy_gui_type"
    makeWrapper "$VENTOY_PATH/VentoyGUI.$ARCH" "$out/bin/ventoy-gui" \
                --prefix PATH : "${lib.makeBinPath buildInputs}" \
                --run "cd '$VENTOY_PATH' || exit 1"
  '' + lib.optionalString (!withGtk3) ''
    rm "$out"/share/ventoy/tool/"$ARCH"/Ventoy2Disk.gtk3
  '' + lib.optionalString (!withQt5) ''
    rm "$out"/share/ventoy/tool/"$ARCH"/Ventoy2Disk.qt5
  '';

  meta = with lib; {
    description = "An open source tool to create bootable USB drive for ISO/WIM/IMG/VHD(x)/EFI files";
    longDescription = ''
      An open source tool to create bootable USB drive for
      ISO/WIM/IMG/VHD(x)/EFI files.  With ventoy, you don't need to format the
      disk over and over, you just need to copy the ISO/WIM/IMG/VHD(x)/EFI
      files to the USB drive and boot them directly.  You can copy many files
      at a time and ventoy will give you a boot menu to select them
      (screenshot).  x86 Legacy BIOS, IA32 UEFI, x86_64 UEFI, ARM64 UEFI and
      MIPS64EL UEFI are supported in the same way.  Most type of OS supported
      (Windows/WinPE/Linux/Unix/VMware/Xen...).
    '';
    homepage = "https://www.ventoy.net";
    changelog = "https://www.ventoy.net/doc_news.html";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" "mipsel-linux" ];
    maintainers = with maintainers; [ k4leg ];
  };
}
