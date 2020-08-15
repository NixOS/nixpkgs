{ pkgsi686Linux
, stdenv
, fetchurl
, dpkg
, makeWrapper
, coreutils
, ghostscript
, gnugrep
, gnused
, which
, lib
, gawk
, a2ps
, file
}:

let
  model = "mfc9332cdw";
  relpath_printer = "opt/brother/Printers/${model}";
in rec {
  mfc9332cdwlpr = pkgsi686Linux.stdenv.mkDerivation rec {
    version = "1.1.3-0";
    name = "${model}drv-${version}";
    dlfid = "dlf101620";
    relpath_lpd = "${relpath_printer}/lpd";

    src = fetchurl {
      url = "https://download.brother.com/welcome/${dlfid}/${model}lpr-${version}.i386.deb";
      sha256 = "8ab136ef6a99f7abb6ee31f75218c29ba02a45a9dbc2ae3014bd11be2e67b856";
    };

    nativeBuildInputs = [ dpkg makeWrapper ];

    unpackPhase = "dpkg-deb -x $src $out";

    patchPhase = ''
      substituteInPlace $out/${relpath_lpd}/filter${model} \
        --replace "/opt" "$out/opt"

      # need to use i686 glibc here, these are 32bit proprietary binaries
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/${relpath_lpd}/br${model}filter

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/usr/bin/brprintconf_${model}
    '';

    installPhase = ''
      wrapProgram $out/${relpath_lpd}/psconvertij2 \
        --prefix PATH : ${stdenv.lib.makeBinPath [ gnused coreutils gawk ]}

      wrapProgram $out/${relpath_lpd}/filter${model} \
        --prefix PATH : ${stdenv.lib.makeBinPath [ ghostscript a2ps file gnugrep which gnused coreutils ]}
    '';

    meta = with lib; {
      description = "Brother ${lib.strings.toUpper model} driver";
      homepage = "http://www.brother.com";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" "i686-linux" ];
      maintainers = with maintainers; [ felixsinger ];
    };
  };

  mfc9332cdwcupswrapper = stdenv.mkDerivation rec {
    version = "1.1.4-0";
    name = "${model}cupswrapper-${version}";
    dlfid = "dlf101642";
    relpath_wrapper = "${relpath_printer}/cupswrapper";

    src = fetchurl {
      url = "https://download.brother.com/welcome/${dlfid}/${model}_cupswrapper_GPL_source_${version}.tar.gz";
      sha256 = "4d9a37d0934b3ba2f67f62ad85c3cc212bf10cf891df7f354f60714cbeb0bd0f";
    };

    buildInputs = [ mfc9332cdwlpr ];
    nativeBuildInputs = [ makeWrapper ];

    patchPhase = ''
      wrapper="cupswrapper/cupswrapper${model}"

      substituteInPlace $wrapper \
        --replace ${"'"}''${device_model}${"'"} "Printers" \
        --replace ${"'"}''${printer_model}${"'"} "mfc9332cdw"

      substituteInPlace $wrapper \
        --replace "/usr/share/ppd" "$out/usr/share/ppd" \
        --replace "/usr/share/cups/model" "$out/usr/share/cups/model" \
        --replace "/usr/lib/cups/filter" "$out/lib/cups/filter" \
        --replace "/var/tmp" "$out/var/tmp" \
        --replace "/${relpath_printer}/cupswrapper" "$out/${relpath_wrapper}" \
        --replace "/${relpath_printer}/lpd" "${mfc9332cdwlpr}/${relpath_printer}/lpd" \
        --replace "/${relpath_printer}/inf" "${mfc9332cdwlpr}/${relpath_printer}/inf"

      substituteInPlace $wrapper \
        --replace "\`cp " "\`cp -p " \
        --replace "\`mv " "\`cp -p "
    '';

    buildPhase = ''
      make -C brcupsconfig/ all
    '';

    installPhase = ''
      # create directory layout
      mkdir -p $out/lib/cups/filter
      mkdir -p $out/share/cups/model
      mkdir -p $out/usr/share/ppd/Brother
      mkdir -p $out/${relpath_wrapper}
      # temporary needed for creating the wrapper script
      # through ${relpath_wrapper}/cupswrapper${model}
      mkdir -p $out/var/tmp

      # copy files to ${relpath_wrapper}
      cp brcupsconfig/brcupsconfpt1 $out/${relpath_wrapper}
      cp cupswrapper/cupswrapper${model} $out/${relpath_wrapper}
      cp PPD/brother_${model}_printer_en.ppd $out/${relpath_wrapper}

      # configure permissions
      chmod 755 $out/${relpath_wrapper}/brcupsconfpt1
      chmod 755 $out/${relpath_wrapper}/cupswrapper${model}
      chmod 644 $out/${relpath_wrapper}/brother_${model}_printer_en.ppd

      # create symlinks of ppd file to cups related directories,
      # so that cups knows the printer
      ln $out/${relpath_wrapper}/brother_${model}_printer_en.ppd $out/share/cups/model
      ln $out/${relpath_wrapper}/brother_${model}_printer_en.ppd $out/usr/share/ppd/Brother

      # generate cups wrapper script
      sh $out/${relpath_wrapper}/cupswrapper${model}

      wrapProgram $out/lib/cups/filter/brother_lpdwrapper_${model} \
        --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils gnugrep gnused ]}

      rm -r $out/var/tmp
    '';

    cleanPhase = ''
      make -C brcupsconfig/ clean
    '';

    meta = with lib; {
      description = "Brother ${lib.strings.toUpper model} CUPS wrapper driver";
      homepage = "http://www.brother.com";
      license = licenses.gpl2;
      platforms = [ "x86_64-linux" "i686-linux" ];
      maintainers = with maintainers; [ felixsinger ];
    };
  };
}
