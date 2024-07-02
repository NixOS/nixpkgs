{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, makeWrapper
, perl
, gnused
, ghostscript
, file
, coreutils
, gnugrep
, which
}:

let
  arches = [ "x86_64" "i686" "armv7l" ];

  runtimeDeps = [
    ghostscript
    file
    gnused
    gnugrep
    coreutils
    which
  ];

  model = "dcpl2550dw";
  MODEL = "${lib.strings.toUpper model}";
  version = "4.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103577/${model}pdrv-${version}.i386.deb";
    sha256 = "01mrshcnr911bvd82xrb1sr6xybpsybzcdpjqs6896g56llbqrc0";
  };

in

rec {
  driver = stdenv.mkDerivation {
    pname = "${model}-drv";
    inherit version;
    inherit src;

    nativeBuildInputs = [ dpkg makeWrapper autoPatchelfHook ];
    buildInputs = [ perl ];

    unpackCmd = "dpkg-deb -x $src";

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -ar opt $out/opt

      # delete unnecessary files for the current architecture
      '' + lib.concatMapStrings
      (arch: ''
        echo Deleting files for ${arch}
        rm -r "$out/opt/brother/Printers/${MODEL}/lpd/${arch}"
      '')
      (builtins.filter (arch: arch != stdenv.hostPlatform.linuxArch) arches) + ''

      # delete cupswrapper files
      echo Deleting cupsfilter files
      rm -r "$out/opt/brother/Printers/${MODEL}/cupswrapper"

      # bundled scripts don't understand the arch subdirectories for some reason
      ln -s \
        "$out/opt/brother/Printers/${MODEL}/lpd/${stdenv.hostPlatform.linuxArch}/"* \
        "$out/opt/brother/Printers/${MODEL}/lpd/"

      # Fix global references and replace auto discovery mechanism with hardcoded values
      substituteInPlace $out/opt/brother/Printers/${MODEL}/lpd/lpdfilter \
        --replace "my \$BR_PRT_PATH =" "my \$BR_PRT_PATH = \"$out/opt/brother/Printers/${MODEL}\"; #" \
        --replace "PRINTER =~" "PRINTER = \"${MODEL}\"; #"

      # Make sure all executables have the necessary runtime dependencies available
      find "$out" -executable -and -type f | while read file; do
        wrapProgram "$file" --prefix PATH : "${lib.makeBinPath runtimeDeps}"
      done

      # Symlink driver into a location where CUPS will discover it
      mkdir -p $out/etc/opt/brother/Printers/${MODEL}/inf

      ln -s $out/opt/brother/Printers/${MODEL}/inf/br${model}rc \
            $out/etc/opt/brother/Printers/${MODEL}/inf/br${model}rc
      runHook postInstall
    '';

    meta = with lib; {
      homepage = "http://www.brother.com/";
      description = "Brother ${MODEL} printer driver";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      platforms = builtins.map (arch: "${arch}-linux") arches;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_eu&os=128";
      maintainers = with maintainers; [ p4p4j0hn ];
    };
  };
  cupswrapper = stdenv.mkDerivation {
    pname = "${model}-cupswrapper";
    inherit version;
    inherit src;

    nativeBuildInputs = [ dpkg makeWrapper ];
    buildInputs = [ perl ];

    unpackCmd = "dpkg-deb -x $src";

    patches = [
      # The brother lpdwrapper uses a temporary file to convey the printer settings.
      # The original settings file will be copied with "400" permissions and the "brprintconflsr3"
      # binary cannot alter the temporary file later on. This fixes the permissions so the can be modified.
      # Since this is all in briefly in the temporary directory of systemd-cups and not accessible by others,
      # it shouldn't be a security concern.
      ./fix-perm.patch
    ];

    installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -ar opt $out/opt

    # Remove non-free driver files
    echo Removing non-free driver files
    rm -r "$out/opt/brother/Printers/${MODEL}/lpd"
    rm -r "$out/opt/brother/Printers/${MODEL}/inf"

    # Fix global references and replace auto discovery mechanism with hardcoded values
    substituteInPlace $out/opt/brother/Printers/${MODEL}/cupswrapper/lpdwrapper \
      --replace "my \$basedir = C" "my \$basedir = \"$out/opt/brother/Printers/${MODEL}\" ; #" \
      --replace "PRINTER =~" "PRINTER = \"${MODEL}\"; #"

    # Make sure all executables have the necessary runtime dependencies available
    find "$out" -executable -and -type f | while read file; do
      wrapProgram "$file" --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    done

    # Symlink filter and ppd into a location where CUPS will discover it
    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln -s \
      $out/opt/brother/Printers/${MODEL}/cupswrapper/lpdwrapper \
      $out/lib/cups/filter/brother_lpdwrapper_${MODEL}
    ln -s \
      $out/opt/brother/Printers/${MODEL}/cupswrapper/brother-${MODEL}-cups-en.ppd \
      $out/share/cups/model/
    runHook postInstall
    '';

    meta = with lib; {
      homepage = "http://www.brother.com/";
      description = "Brother ${MODEL} cups wrapper";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.gpl2;
      platforms = builtins.map (arch: "${arch}-linux") arches;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_eu&os=128";
      maintainers = with maintainers; [ p4p4j0hn ];
    };
  };
}
