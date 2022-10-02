{ lib, stdenv, fetchurl, zlib, pciutils, coreutils, acpica-tools, makeWrapper, gnugrep, gnused, file, buildEnv }:

let
  version = "4.14";

  commonMeta = with lib; {
    description = "Various coreboot-related tools";
    homepage = "https://www.coreboot.org";
    license = with licenses; [ gpl2Only gpl2Plus ];
    maintainers = with maintainers; [ felixsinger yuka ];
    platforms = platforms.linux;
  };

  generic = { pname, path ? "util/${pname}", ... }@args: stdenv.mkDerivation (rec {
    inherit pname version;

    src = fetchurl {
      url = "https://coreboot.org/releases/coreboot-${version}.tar.xz";
      sha256 = "0viw2x4ckjwiylb92w85k06b0g9pmamjy2yqs7fxfqbmfadkf1yr";
    };

    enableParallelBuilding = true;

    postPatch = ''
      cd ${path}
      patchShebangs .
    '';

    makeFlags = [
      "INSTALL=install"
      "PREFIX=${placeholder "out"}"
    ];

    meta = commonMeta // args.meta;
  } // (removeAttrs args ["meta"]));

  utils = {
    msrtool = generic {
      pname = "msrtool";
      meta.description = "Dump chipset-specific MSR registers";
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
      buildInputs = [ pciutils zlib ];
      meta.platforms = [ "x86_64-linux" "i686-linux" ];
    };
    cbfstool = generic {
      pname = "cbfstool";
      meta.description = "Management utility for CBFS formatted ROM images";
    };
    nvramtool = generic {
      pname = "nvramtool";
      meta.description = "Read and write coreboot parameters and display information from the coreboot table in CMOS/NVRAM";
    };
    superiotool = generic {
      pname = "superiotool";
      meta.description = "User-space utility to detect Super I/O of a mainboard and provide detailed information about the register contents of the Super I/O";
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
      buildInputs = [ pciutils zlib ];
      meta.platforms = [ "x86_64-linux" "i686-linux" ];
    };
    amdfwtool = generic {
      pname = "amdfwtool";
      meta.description = "Create AMD firmware combination";
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
      postFixup = let
        binPath = [ coreutils acpica-tools gnugrep gnused file ];
      in "wrapProgram $out/bin/acpidump-all --set PATH ${lib.makeBinPath binPath}";
    };
  };

in utils // {
  coreboot-utils = (buildEnv {
    name = "coreboot-utils-${version}";
    paths = lib.attrValues utils;
    postBuild = "rm -rf $out/sbin";
  }) // {
    inherit version;
    meta = commonMeta;
  };
}
