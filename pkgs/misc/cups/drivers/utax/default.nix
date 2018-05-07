{ stdenv, fetchurl, patchelf, mmv, cups }:

stdenv.mkDerivation rec {
  name = "utax-ppd-${version}";
  version = "20140115";

  src = fetchurl {
    url = http://www.utax.de/C125712200447418/vwLookupDownloads/TALinuxPackages_cCD-cLP_20140115.tar.gz/$FILE/TALinuxPackages_cCD-cLP_20140115.tar.gz;
    sha256 = "d5031282b32266912f08c9f9b19b092c93e8aabda925d83a505e48e185e172ad";
  };

  nativeBuildInputs = [ patchelf mmv ];
  buildInputs = [ cups ];
  inherit cups;

  outputs = [ "out" "French" "German" "Italian" "Portuguese" "Spanish" ]; 

  preferLocalBuild = true;
  archdir = if stdenv.hostPlatform.system == "x86_64-linux" then "64bit"
       else if stdenv.hostPlatform.system == "i686-linux"   then "32bit"
       else throw "Error: Platform '${stdenv.hostPlatform.system}' not supported, currently Linux i686/x86_64 only";

  buildPhase = ''
    # patch kyofilter_B
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "LP 3335_LP 4335 series/$archdir/EU/English/kyofilter_B"
    patchelf --set-rpath ${cups.lib}/lib "LP 3335_LP 4335 series/$archdir/EU/English/kyofilter_B"

    # fix ppd-filenames
    mmv "*/*/*/*/*.PPD" "#1/#2/#3/#4/#5.ppd"
  '';

  installPhase = ''
    # install kyofilter_B
    mkdir -p "$out/bin"
    cp "LP 3335_LP 4335 series/$archdir/EU/English/kyofilter_B" "$out/bin/"
    chmod 555 "$out/bin/kyofilter_B"

    # copy all ppds
    mkdir -p "$out/share/cups/model/UTAX_TA/"
    mkdir -p "$out/share/cups/model/UTAX_TA/English"
    mkdir -p "$French/share/cups/model/UTAX_TA/French"
    mkdir -p "$German/share/cups/model/UTAX_TA/German"
    mkdir -p "$Italian/share/cups/model/UTAX_TA/Italian"
    mkdir -p "$Portuguese/share/cups/model/UTAX_TA/Portuguese"
    mkdir -p "$Spanish/share/cups/model/UTAX_TA/Spanish"
    mcp "*/$archdir/EU/English/*.ppd"           "$out/share/cups/model/UTAX_TA/English/#2.ppd"
    mcp "*/$archdir/EU/French/*.ppd"         "$French/share/cups/model/UTAX_TA/French/#2.ppd"
    mcp "*/$archdir/EU/German/*.ppd"         "$German/share/cups/model/UTAX_TA/German/#2.ppd"
    mcp "*/$archdir/EU/Italian/*.ppd"       "$Italian/share/cups/model/UTAX_TA/Italian/#2.ppd"
    mcp "*/$archdir/EU/Portuguese/*.ppd" "$Portuguese/share/cups/model/UTAX_TA/Portuguese/#2.ppd"
    mcp "*/$archdir/EU/Spanish/*.ppd"       "$Spanish/share/cups/model/UTAX_TA/Spanish/#2.ppd"
  '';

  preFixup = ''
    # fix path to kyofilter_B
    for dir in $out $French $German $Italian $Portuguese $Spanish; do
        for f in $dir/share/cups/model/UTAX_TA/*/*.ppd; do
            substituteInPlace "$f" --replace "/usr/lib/cups/filter/kyofilter_B" "$out/bin/kyofilter_B"
        done
    done
  '';

  meta = with stdenv.lib; {
    description = "CUPS drivers for UTAX printers";
    long_description = ''
      Printer driver for UTAX printers, for CUPS, english version,
      directly from the manufacturer.
      UTAX printers are mostly re-branded Kyocera printers.
      Only for Linux i686 and x86_64.

      Supported printer-series: CD*, CDC*, CLP*, DC*, LP*, TA*.

      Available languages: English, French, German, Italian, Portuguese, Spanish.
      By default, only the English PPD-versions are installed.
      '';
    homepage = "http://www.utax.de/";
    license = licenses.mit;
    maintainers = [ maintainers.rkoe ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
