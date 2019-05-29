{ stdenv, fetchurl, gnu-efi
, dmraid ? null, glibc ? null, efibootmgr ? null, imagemagick ? null
, openssl ? null, sbsigntool ? null
, enableBloat ? false
}:

assert enableBloat -> dmraid != null;
assert enableBloat -> glibc != null;
assert enableBloat -> imagemagick != null;
assert enableBloat -> openssl != null;
assert enableBloat -> sbsigntool != null;

let
  archids = {
    x86_64-linux = { hostarch = "x86_64"; efiPlatform = "x64"; };
    i686-linux = rec { hostarch = "ia32"; efiPlatform = hostarch; };
    aarch64-linux = { hostarch = "aarch64"; efiPlatform = "aa64"; };
  };

  inherit
    (archids.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}"))
    hostarch efiPlatform;
in

stdenv.mkDerivation rec {
  pname = "refind";
  version = "0.11.4";
  srcName = "refind-src-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/refind/${version}/${srcName}.tar.gz";
    sha256 = "1bjd0dl77bc5k6g3kc7s8m57vpbg2zscph9qh84xll9rc10g3fir";
  };

  patches = [
    ./0001-toolchain.patch
  ];

  buildInputs = [ gnu-efi ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags =
    [ "prefix="
      "EFIINC=${gnu-efi}/include/efi"
      "EFILIB=${gnu-efi}/lib"
      "GNUEFILIB=${gnu-efi}/lib"
      "EFICRT0=${gnu-efi}/lib"
      "HOSTARCH=${hostarch}"
      "ARCH=${hostarch}"
    ];

  buildFlags = [ "gnuefi" "fs_gnuefi" ];

  installPhase = ''
    install -d ''${!outputBin}/bin/
    install -d ''${!outputBin}/share/refind/drivers_${efiPlatform}/
    install -d ''${!outputBin}/share/refind/tools_${efiPlatform}/
    install -d ''${!outputBin}/share/refind/docs/html/
    install -d ''${!outputBin}/share/refind/docs/Styles/
    install -d ''${!outputBin}/share/refind/fonts/
    install -d ''${!outputBin}/share/refind/icons/
    install -d ''${!outputBin}/share/refind/images/
    install -d ''${!outputBin}/share/refind/keys/

    # rEFInd UEFI app
    install -D -m0644 refind/refind_${efiPlatform}.efi ''${!outputBin}/share/refind/refind_${efiPlatform}.efi

    # UEFI drivers
    install -D -m0644 drivers_${efiPlatform}/*.efi ''${!outputBin}/share/refind/drivers_${efiPlatform}/

    # UEFI apps
    install -D -m0644 gptsync/gptsync_${efiPlatform}.efi ''${!outputBin}/share/refind/tools_${efiPlatform}/gptsync_${efiPlatform}.efi

    # helper scripts
    install -D -m0755 refind-install ''${!outputBin}/bin/refind-install
    install -D -m0755 mkrlconf ''${!outputBin}/bin/refind-mkrlconf
    install -D -m0755 mvrefind ''${!outputBin}/bin/refind-mvrefind
    install -D -m0755 fonts/mkfont.sh ''${!outputBin}/bin/refind-mkfont

    # sample config files
    install -D -m0644 refind.conf-sample ''${!outputBin}/share/refind/refind.conf-sample

    # docs
    install -D -m0644 docs/refind/* ''${!outputDoc}/share/refind/docs/html/
    install -D -m0644 docs/Styles/* ''${!outputDoc}/share/refind/docs/Styles/
    install -D -m0644 README.txt ''${!outputDoc}/share/refind/docs/README.txt
    install -D -m0644 NEWS.txt ''${!outputDoc}/share/refind/docs/NEWS.txt
    install -D -m0644 BUILDING.txt ''${!outputDoc}/share/refind/docs/BUILDING.txt
    install -D -m0644 CREDITS.txt ''${!outputDoc}/share/refind/docs/CREDITS.txt

    # fonts
    install -D -m0644 fonts/* ''${!outputBin}/share/refind/fonts/
    rm -f ''${!outputBin}/share/refind/fonts/mkfont.sh

    # icons
    install -D -m0644 icons/*.png ''${!outputBin}/share/refind/icons/

    # images
    install -D -m0644 images/*.{png,bmp} ''${!outputBin}/share/refind/images/

    # keys
    install -D -m0644 keys/* ''${!outputBin}/share/refind/keys/

    # Fix variable definition of 'RefindDir' which is used to locate ressource files.
    sed -i "s,\bRefindDir=.*,RefindDir=''${!outputBin}/share/refind,g" ''${!outputBin}/bin/refind-install

    ${let
      inherit (stdenv) lib;
      inherit (lib) elemAt escapeShellArg getBin;
      pinBin = args: let
        var = elemAt args 0; bin = elemAt args 1; path = elemAt args 2;
        match = "${var}=`which ${bin} 2> /dev/null`";
        rep = "${var}=${escapeShellArg path}";
      in "  --replace ${escapeShellArg match} \\\n    ${escapeShellArg rep}";
      pinBinsIn = path: pins:
        lib.concatStringsSep " \\\n" ([
          ''substituteInPlace ${path}''
        ] ++ builtins.map pinBin pins);
      efibootmgrPin =
        [ "Efibootmgr" "efibootmgr" "${getBin efibootmgr}/bin/efibootmgr" ];
      iconvPin = [ "IConv" "iconv" "${getBin glibc}/bin/iconv" ];
    in if enableBloat then ''
      # Patch uses of `which` to direct paths.
      ${pinBinsIn "\${!outputBin}/bin/refind-install" [
        [ "Dmraid" "dmraid" "${getBin dmraid}/bin/dmraid" ]
        efibootmgrPin
        iconvPin
        [ "OpenSSL" "openssl" "${getBin openssl}/bin/openssl" ]
        [ "SBSign" "sbsign" "${getBin sbsigntool}/bin/sbsign" ]
      ]}
      ${pinBinsIn "\${!outputBin}/bin/refind-mvrefind" [
        efibootmgrPin
        iconvPin
      ]}
      ${pinBinsIn "\${!outputBin}/bin/refind-mkfont" [
        [ "Convert" "convert" "${getBin imagemagick}/bin/convert" ]
      ]}'' else ''
      # Patch uses of `which`.  We could patch in calls to efibootmgr,
      # openssl, convert, and openssl, but that would greatly enlarge
      # rEFInd's closure (from ~35MB to ~250MB).
      sed -i 's,`which \(.*\)`,`type -p \1`,g' ''${!outputBin}/bin/refind-install
      sed -i 's,`which \(.*\)`,`type -p \1`,g' ''${!outputBin}/bin/refind-mvrefind
      sed -i 's,`which \(.*\)`,`type -p \1`,g' ''${!outputBin}/bin/refind-mkfont''
    }
  '';

  meta = with stdenv.lib; {
    description = "A graphical {,U}EFI boot manager";
    longDescription = ''
      rEFInd is a graphical boot manager for EFI- and UEFI-based
      computers, such as all Intel-based Macs and recent (most 2011
      and later) PCs. rEFInd presents a boot menu showing all the EFI
      boot loaders on the EFI-accessible partitions, and optionally
      BIOS-bootable partitions on Macs. EFI-compatbile OSes, including
      Linux, provide boot loaders that rEFInd can detect and
      launch. rEFInd can launch Linux EFI boot loaders such as ELILO,
      GRUB Legacy, GRUB 2, and 3.3.0 and later kernels with EFI stub
      support. EFI filesystem drivers for ext2/3/4fs, ReiserFS, HFS+,
      and ISO-9660 enable rEFInd to read boot loaders from these
      filesystems, too. rEFInd's ability to detect boot loaders at
      runtime makes it very easy to use, particularly when paired with
      Linux kernels that provide EFI stub support.
    '';
    homepage = https://www.rodsbooks.com/refind/;
    downloadPage = "https://sourceforge.net/projects/refind/files/${version}/";
    maintainers = [ maintainers.AndersonTorres maintainers.bb010g ];
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
    license = licenses.gpl3Plus;
  };

}
