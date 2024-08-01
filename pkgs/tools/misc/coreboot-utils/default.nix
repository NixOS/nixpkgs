{ lib, stdenv, fetchgit, pkg-config, zlib, pciutils, openssl, coreutils, acpica-tools, makeWrapper, gnugrep, gnused, file, buildEnv }:

let
  version = "24.05";

  commonMeta = with lib; {
    description = "Various coreboot-related tools";
    homepage = "https://www.coreboot.org";
    license = with licenses; [ gpl2Only gpl2Plus ];
    maintainers = with maintainers; [ felixsinger jmbaur ];
    platforms = platforms.linux;
  };

  generic = { pname, path ? "util/${pname}", ... }@args: stdenv.mkDerivation ({
    inherit pname version;

    src = fetchgit {
      url = "https://review.coreboot.org/coreboot";
      rev = version;
      hash = "sha256-Fq3tZje6QoMskxqWd61OstgI9Sj25yijf8S3LiTJuYc=";
    };

    enableParallelBuilding = true;

    postPatch = ''
      substituteInPlace 3rdparty/vboot/Makefile --replace 'ar qc ' '$$AR qc '
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
      meta.platforms = [ "x86_64-linux" "i686-linux" ];
      buildInputs = [ pciutils zlib ];
    };
    cbfstool = generic {
      pname = "cbfstool";
      meta.description = "Management utility for CBFS formatted ROM images";
    };
    nvramtool = generic {
      pname = "nvramtool";
      meta.description = "Read and write coreboot parameters and display information from the coreboot table in CMOS/NVRAM";
      meta.mainProgram = "nvramtool";
    };
    superiotool = generic {
      pname = "superiotool";
      meta.description = "User-space utility to detect Super I/O of a mainboard and provide detailed information about the register contents of the Super I/O";
      meta.platforms = [ "x86_64-linux" "i686-linux" ];
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
      meta.platforms = [ "x86_64-linux" "i686-linux" ];
      buildInputs = [ pciutils zlib ];
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
    paths = lib.filter (lib.meta.availableOn stdenv.hostPlatform) (lib.attrValues utils);
    postBuild = "rm -rf $out/sbin";
  }) // {
    inherit version;
    meta = commonMeta;
  };
}
