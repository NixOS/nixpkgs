{ stdenv, fetchurl, patchelf, cups, gcc }:

let
  arch = if stdenv.system == "x86_64-linux" then "64bit" else "32bit";
  region = "Global";
  lang = "English";
in

stdenv.mkDerivation rec {
  name = "triumph-adler-${version}";
  version = "20140115";

  src = fetchurl {
    url = "http://www.triumph-adler.de/C125712200447418/vwLookupDownloads/TALinuxPackages_cCD-cLP_${version}.tar.gz/$FILE/TALinuxPackages_cCD-cLP_${version}.tar.gz";
    sha256 = "1bbjw62y2j2ya0xdh9d9pnmfi4rc16dv3yf910pr2ri2nf1140ym";
  };

  buildInputs = [ cups patchelf gcc ];

  installPhase = ''
    # Install all PPD files
    mkdir -p "$out/share/cups/model/UTAX_TA/"
    find */${arch}/${region}/${lang}/ -type f -name "*.PPD" \
      -exec cp {} $out/share/cups/model/UTAX_TA/ \;

    # There are hundreds of filters but they don't differ from each other so we
    # just pick the first one.
    mkdir -p "$out/lib/cups/filter/"
    cp "206ci series/${arch}/${region}/${lang}/kyofilter_B" \
      $out/lib/cups/filter/
    chmod a+x $out/lib/cups/filter/kyofilter_B
  '';

  preFixup = ''
    # Remove hard coded prefixes
    for file in $out/share/cups/model/UTAX_TA/*; do
      substituteInPlace "$file" \
        --replace /usr/lib/cups/filter/ ""
    done

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $cups/lib:$gcc/lib \
      $out/lib/cups/filter/kyofilter_B
  '';

  meta = with stdenv.lib; {
    description = "CUPS driver for TA Triumph-Adler printers";
    homepage = https://www.triumph-adler.de;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
