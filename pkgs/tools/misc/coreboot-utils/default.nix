<<<<<<< HEAD
{ lib, stdenv, fetchgit, pkg-config, zlib, pciutils, openssl, coreutils, acpica-tools, makeWrapper, gnugrep, gnused, file, buildEnv }:

let
  version = "4.21";
=======
{ lib, stdenv, fetchurl, pkg-config, zlib, pciutils, openssl, coreutils, acpica-tools, makeWrapper, gnugrep, gnused, file, buildEnv }:

let
  version = "4.19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  commonMeta = with lib; {
    description = "Various coreboot-related tools";
    homepage = "https://www.coreboot.org";
    license = with licenses; [ gpl2Only gpl2Plus ];
    maintainers = with maintainers; [ felixsinger yuka ];
    platforms = platforms.linux;
  };

  generic = { pname, path ? "util/${pname}", ... }@args: stdenv.mkDerivation (rec {
    inherit pname version;

<<<<<<< HEAD
    src = fetchgit {
      url = "https://review.coreboot.org/coreboot";
      rev = "c1386ef6128922f49f93de5690ccd130a26eecf2";
      sha256 = "sha256-n/bo3hoY7DEP103ftWu3uCLFXEsz+F9rWS22kcF7Ah8=";
=======
    src = fetchurl {
      url = "https://coreboot.org/releases/coreboot-${version}.tar.xz";
      sha256 = "sha256-Zcyy9GU1uZbgBmobdvgcjPH/PiffhLP5fYrXs+fPCkM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    enableParallelBuilding = true;

    postPatch = ''
<<<<<<< HEAD
      substituteInPlace 3rdparty/vboot/Makefile --replace 'ar qc ' '$$AR qc '
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      cd ${path}
      patchShebangs .
    '';

    makeFlags = [
      "INSTALL=install"
      "PREFIX=${placeholder "out"}"
    ];

    meta = commonMeta // args.meta;
  } // (removeAttrs args [ "meta" ]));

  utils = {
    msrtool = generic {
      pname = "msrtool";
      meta.description = "Dump chipset-specific MSR registers";
      meta.platforms = [ "x86_64-linux" "i686-linux" ];
      buildInputs = [ pciutils zlib ];
      preConfigure = "export INSTALL=install";
    };
    cbmem = generic {
      pname = "cbmem";
      meta.description = "coreboot console log reader";
    };
    ifdtool = generic {
      pname = "ifdtool";
      meta.description = "Extract and dump Intel Firmware Descriptor information";
    };
    intelmetool = generic {
      pname = "intelmetool";
      meta.description = "Dump interesting things about Management Engine";
<<<<<<< HEAD
      meta.platforms = [ "x86_64-linux" "i686-linux" ];
      buildInputs = [ pciutils zlib ];
=======
      buildInputs = [ pciutils zlib ];
      meta.platforms = [ "x86_64-linux" "i686-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
    cbfstool = generic {
      pname = "cbfstool";
      meta.description = "Management utility for CBFS formatted ROM images";
    };
    nvramtool = generic {
      pname = "nvramtool";
      meta.description = "Read and write coreboot parameters and display information from the coreboot table in CMOS/NVRAM";
<<<<<<< HEAD
      meta.mainProgram = "nvramtool";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
    superiotool = generic {
      pname = "superiotool";
      meta.description = "User-space utility to detect Super I/O of a mainboard and provide detailed information about the register contents of the Super I/O";
<<<<<<< HEAD
      meta.platforms = [ "x86_64-linux" "i686-linux" ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      buildInputs = [ pciutils zlib ];
    };
    ectool = generic {
      pname = "ectool";
      meta.description = "Dump the RAM of a laptop's Embedded/Environmental Controller (EC)";
      meta.platforms = [ "x86_64-linux" "i686-linux" ];
      preInstall = "mkdir -p $out/sbin";
    };
    inteltool = generic {
      pname = "inteltool";
      meta.description = "Provides information about Intel CPU/chipset hardware configuration (register contents, MSRs, etc)";
<<<<<<< HEAD
      meta.platforms = [ "x86_64-linux" "i686-linux" ];
      buildInputs = [ pciutils zlib ];
=======
      buildInputs = [ pciutils zlib ];
      meta.platforms = [ "x86_64-linux" "i686-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
    amdfwtool = generic {
      pname = "amdfwtool";
      meta.description = "Create AMD firmware combination";
      buildInputs = [ openssl ];
      nativeBuildInputs = [ pkg-config ];
      installPhase = ''
        runHook preInstall

        install -Dm755 amdfwtool $out/bin/amdfwtool

        runHook postInstall
      '';
    };
    acpidump-all = generic {
      pname = "acpidump-all";
      path = "util/acpi";
      meta.description = "Walk through all ACPI tables with their addresses";
      nativeBuildInputs = [ makeWrapper ];
      dontBuild = true;
      installPhase = ''
        runHook preInstall

        install -Dm755 acpidump-all $out/bin/acpidump-all

        runHook postInstall
      '';
      postFixup = ''
        wrapProgram $out/bin/acpidump-all \
          --set PATH ${lib.makeBinPath [ coreutils acpica-tools gnugrep gnused file ]}
      '';
    };
  };

in
utils // {
  coreboot-utils = (buildEnv {
    name = "coreboot-utils-${version}";
<<<<<<< HEAD
    paths = lib.filter (lib.meta.availableOn stdenv.hostPlatform) (lib.attrValues utils);
=======
    paths = lib.attrValues utils;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    postBuild = "rm -rf $out/sbin";
  }) // {
    inherit version;
    meta = commonMeta;
  };
}
