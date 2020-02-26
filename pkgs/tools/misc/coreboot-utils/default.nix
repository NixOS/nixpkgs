{ stdenv, fetchurl, zlib, pciutils, coreutils, acpica-tools, iasl, makeWrapper, gnugrep, gnused, file, buildEnv }:

let
  version = "4.11";

  meta = with stdenv.lib; {
    description = "Various coreboot-related tools";
    homepage = "https://www.coreboot.org";
    license = licenses.gpl2;
    maintainers = [ maintainers.petabyteboy ];
    platforms = platforms.linux;
  };

  generic = { pname, path ? "util/${pname}", ... }@args: stdenv.mkDerivation (rec {
    inherit pname version meta;

    src = fetchurl {
      url = "https://coreboot.org/releases/coreboot-${version}.tar.xz";
      sha256 = "11xdm2c1blaqb32j98085sak78jldsw0xhrkzqs5b8ir9jdqbzcp";
    };

    enableParallelBuilding = true;

    postPatch = ''
      cd ${path}
    '';

    makeFlags = [
      "INSTALL=install"
      "PREFIX=${placeholder "out"}"
    ];
  } // args);

  utils = {
    msrtool = generic {
      pname = "msrtool";
      meta.description = "Dump chipset-specific MSR registers";
      buildInputs = [ pciutils zlib ];
      preConfigure = "export INSTALL=install";
    };
    cbmem = generic {
      pname = "cbmem";
      meta.description = "Coreboot console log reader";
    };
    ifdtool = generic {
      pname = "ifdtool";
      meta.description = "Extract and dump Intel Firmware Descriptor information";
    };
    intelmetool = generic {
      pname = "intelmetool";
      meta.description = "Dump interesting things about Management Engine";
      buildInputs = [ pciutils zlib ];
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
    };
    amdfwtool = generic {
      pname = "amdfwtool";
      meta.description = "Create AMD firmware combination";
      installPhase = "install -Dm755 amdfwtool $out/bin/amdfwtool";
    };
    acpidump-all = generic {
      pname = "acpidump-all";
      path = "util/acpi";
      meta.description = "Walk through all ACPI tables with their addresses";
      nativeBuildInputs = [ makeWrapper ];
      dontBuild = true;
      installPhase = "install -Dm755 acpidump-all $out/bin/acpidump-all";
      postFixup = let 
        binPath = [ coreutils  acpica-tools iasl gnugrep  gnused  file ];
      in "wrapProgram $out/bin/acpidump-all --set PATH ${stdenv.lib.makeBinPath binPath}";
    };
  };

in utils // {
  coreboot-utils = (buildEnv {
    name = "coreboot-utils-${version}";
    paths = stdenv.lib.attrValues utils;
    postBuild = "rm -rf $out/sbin";
  }) // {
    inherit meta version;
  };
}
