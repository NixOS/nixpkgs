{ fetchurl, stdenv, python
, unzip ? null
, enableDitaaFilter ? false, jre ? null
, enableMscgenFilter ? false, mscgen ? null
, enableDiagFilter ? false, blockdiag ? null, seqdiag ? null, actdiag ? null, nwdiag ? null
, enableQrcodeFilter ? false, qrencode ? null
}:

assert (enableDitaaFilter || enableMscgenFilter || enableDiagFilter || enableQrcodeFilter) -> unzip != null;
assert enableDitaaFilter -> jre != null;
assert enableMscgenFilter -> mscgen != null;
assert enableDiagFilter -> blockdiag != null && seqdiag != null && actdiag != null && nwdiag != null;

let
  ditaaFilterSrc = fetchurl {
    url = "https://asciidoc-ditaa-filter.googlecode.com/files/ditaa-filter-1.1.zip";
    sha256 = "0p7hm2a1xywx982ia3vg4c0lam5sz0xknsc10i2a5vswy026naf6";
  };

  mscgenFilterSrc = fetchurl {
    url = "https://asciidoc-mscgen-filter.googlecode.com/files/mscgen-filter-1.2.zip";
    sha256 = "1nfwmj375gpv5dn9i770pjv59aihzy2kja0fflsk96xwnlqsqq61";
  };

  diagFilterSrc = fetchurl {
    # unfortunately no version number
    url = "https://asciidoc-diag-filter.googlecode.com/files/diag_filter.zip";
    sha256 = "1qlqrdbqkdqqgfdhjsgdws1al0sacsyq6jmwxdfy7r8k7bv7n7mm";
  };

  qrcodeFilterSrc = fetchurl {
    url = "https://asciidoc-qrencode-filter.googlecode.com/files/qrcode-filter-1.0.zip";
    sha256 = "0h4bql1nb4y4fmg2yvlpfjhvy22ln8jsaxdr10f8bfcg5lr0zkxs";
  };

in

stdenv.mkDerivation rec {
  name = "asciidoc-8.6.8";

  src = fetchurl {
    url = "mirror://sourceforge/asciidoc/${name}.tar.gz";
    sha256 = "ffb67f59dccaf6f15db72fcd04fdf21a2f9b703d31f94fcd0c49a424a9fcfbc4";
  };

  buildInputs = [ python unzip ];

  # install filters early, so their shebangs are patched too
  patchPhase = with stdenv.lib; ''
    mkdir -p "$out/etc/asciidoc/filters"
  '' + optionalString enableDitaaFilter ''
    echo "Extracting ditaa filter"
    unzip -d "$out/etc/asciidoc/filters/ditaa" "${ditaaFilterSrc}"
    sed -i -e "s|java -jar|${jre}/bin/java -jar|" \
        "$out/etc/asciidoc/filters/ditaa/ditaa2img.py"
  '' + optionalString enableMscgenFilter ''
    echo "Extracting mscgen filter"
    unzip -d "$out/etc/asciidoc/filters/mscgen" "${mscgenFilterSrc}"
    sed -i -e "s|filter-wrapper.py mscgen|filter-wrapper.py ${mscgen}/bin/mscgen|" \
        "$out/etc/asciidoc/filters/mscgen/mscgen-filter.conf"
  '' + optionalString enableDiagFilter ''
    echo "Extracting diag filter"
    unzip -d "$out/etc/asciidoc/filters/diag" "${diagFilterSrc}"
    sed -i \
        -e "s|filter='blockdiag|filter=\'${blockdiag}/bin/blockdiag|" \
        -e "s|filter='seqdiag|filter=\'${seqdiag}/bin/seqdiag|" \
        -e "s|filter='actdiag|filter=\'${actdiag}/bin/actdiag|" \
        -e "s|filter='nwdiag|filter=\'${nwdiag}/bin/nwdiag|" \
        -e "s|filter='packetdiag|filter=\'${nwdiag}/bin/packetdiag|" \
        "$out/etc/asciidoc/filters/diag/diag-filter.conf"
  '' + optionalString enableQrcodeFilter ''
    echo "Extracting qrcode filter"
    unzip -d "$out/etc/asciidoc/filters/qrcode" "${qrcodeFilterSrc}"
    sed -i -e "s|systemcmd('qrencode|systemcmd('${qrencode}/bin/qrencode|" \
        "$out/etc/asciidoc/filters/qrcode/qrcode2img.py"
  '' + ''
    for n in $(find "$out" . -name \*.py); do
      sed -i -e "s,^#![[:space:]]*/usr/bin/env python,#!${python}/bin/python,g" "$n"
      chmod +x "$n"
    done
    sed -i -e "s,/etc/vim,,g" Makefile.in
  '';

  preInstall = "mkdir -p $out/etc/vim";

  meta = {
    homepage = "http://www.methods.co.nz/asciidoc/";
    description = "ASCII text-based document generation system";
    license = "GPLv2+";

    longDescription = ''
      AsciiDoc is a text-based document generation system.  AsciiDoc
      input files can be translated to HTML and DocBook markups.
    '';
  };
}
