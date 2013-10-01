{ fetchurl, stdenv, python
, unzip ? null
# filters
, enableDitaaFilter ? false, jre ? null
, enableMscgenFilter ? false, mscgen ? null
, enableDiagFilter ? false, blockdiag ? null, seqdiag ? null, actdiag ? null, nwdiag ? null
, enableQrcodeFilter ? false, qrencode ? null
, enableMatplotlibFilter ? false, matplotlib ? null, numpy ? null
, enableAafigureFilter ? false, aafigure ? null, recursivePthLoader ? null
# backends
, enableDeckjsBackend ? false
, enableOdfBackend ? false
}:

# filters
assert (enableDitaaFilter || enableMscgenFilter || enableDiagFilter || enableQrcodeFilter || enableAafigureFilter) -> unzip != null;
assert enableDitaaFilter -> jre != null;
assert enableMscgenFilter -> mscgen != null;
assert enableDiagFilter -> blockdiag != null && seqdiag != null && actdiag != null && nwdiag != null;
assert enableMatplotlibFilter -> matplotlib != null && numpy != null;
assert enableAafigureFilter -> aafigure != null && recursivePthLoader != null;
# backends
assert (enableDeckjsBackend || enableOdfBackend) -> unzip != null;

let

  #
  # filters
  #

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

  # latest commit in master branch as per 2013-09-22
  matplotlibFilterSrc = let commit = "75f0d009629f93f33fab04b83faca20cc35dd358"; in fetchurl rec {
    name = "mplw-${commit}.tar.gz";
    url = "https://api.github.com/repos/lvv/mplw/tarball/${commit}";
    sha256 = "0yfhkm2dr8gnp0fcg25x89hwiymkri2m5cyqzmzragzwj0hbmcf1";
  };

  aafigureFilterSrc = fetchurl {
    url = "https://asciidoc-aafigure-filter.googlecode.com/files/aafigure-filter-1.1.zip";
    sha256 = "1hq2s30dvmv5dqvj0xm1qwdwafhgm9w1iyr0lr0c40cyk8h00j8j";
  };

  #
  # backends
  #

  deckjsBackendSrc = fetchurl {
    url = "https://github.com/downloads/houqp/asciidoc-deckjs/deckjs-1.6.2.zip";
    sha256 = "1siy1j8naj5irrrrv5bfgl4d8nal6j9pyahy4f50wmrr9wv59s46";
  };

  # the odf backend is actually two plugins: odt + odp
  odtBackendSrc = fetchurl {
    url = "https://github.com/downloads/dagwieers/asciidoc-odf/odt-backend-0.1.zip";
    sha256 = "1zaa97h9sx6ncxcdkl1x3ggydi7f8kjgvrnpjnkjiizi45k350kw";
  };
  odpBackendSrc = fetchurl {
    url = "https://github.com/downloads/dagwieers/asciidoc-odf/odp-backend-0.1.zip";
    sha256 = "08ya4bskygzqkfqwjllpg31qc5k08xp2k78z9b2480g8y57bfy10";
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
    mkdir -p "$out/etc/asciidoc/backends"
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
  '' + optionalString enableMatplotlibFilter ''
    echo "Extracting mpl (matplotlib) filter"
    mkdir -p "$out/etc/asciidoc/filters/mpl"
    tar xvf "${matplotlibFilterSrc}" -C "$out/etc/asciidoc/filters/mpl" --strip-components=1
    # Stop asciidoc from loading mpl/.old/chart-filter.conf
    rm -rf "$out/etc/asciidoc/filters/mpl/.old"
    # Add matplotlib and numpy to sys.path
    matplotlib_path="$(toPythonPath ${matplotlib})"
    numpy_path="$(toPythonPath ${numpy})"
    sed -i "/^import.*sys/asys.path.append(\"$matplotlib_path\"); sys.path.append(\"$numpy_path\");" \
        "$out/etc/asciidoc/filters/mpl/mplw.py"
  '' + optionalString enableAafigureFilter ''
    echo "Extracting aafigure filter"
    unzip -d "$out/etc/asciidoc/filters/aafigure" "${aafigureFilterSrc}"
    # Add aafigure to sys.path (and it needs recursive-pth-loader)
    pth_loader_path="$(toPythonPath ${recursivePthLoader})"
    aafigure_path="$(toPythonPath ${aafigure})"
    sed -i "/^import.*sys/asys.path.append(\"$pth_loader_path\"); sys.path.append(\"$aafigure_path\"); import sitecustomize" \
        "$out/etc/asciidoc/filters/aafigure/aafig2img.py"
  '' + optionalString enableDeckjsBackend ''
    echo "Extracting deckjs backend"
    unzip -d "$out/etc/asciidoc/backends/deckjs" "${deckjsBackendSrc}"
  '' + optionalString enableOdfBackend ''
    echo "Extracting odf backend (odt + odp)"
    unzip -d "$out/etc/asciidoc/backends/odt" "${odtBackendSrc}"
    unzip -d "$out/etc/asciidoc/backends/odp" "${odpBackendSrc}"
    # The odt backend has a TODO note about removing this hardcoded path, but
    # the odp backend already has that fix. Copy it here until fixed upstream.
    sed -i "s|'/etc/asciidoc/backends/odt/asciidoc.ott'|os.path.dirname(__file__),'asciidoc.ott'|" \
        "$out/etc/asciidoc/backends/odt/a2x-backend.py"
  '' + ''
    for n in $(find "$out" . -name \*.py); do
      sed -i -e "s,^#![[:space:]]*.*/bin/env python,#!${python}/bin/python,g" "$n"
      chmod +x "$n"
    done
    sed -i -e "s,/etc/vim,,g" Makefile.in
  '';

  preInstall = "mkdir -p $out/etc/vim";

  meta = with stdenv.lib; {
    description = "Text-based document generation system";
    longDescription = ''
      AsciiDoc is a text document format for writing notes, documentation,
      articles, books, ebooks, slideshows, web pages, man pages and blogs.
      AsciiDoc files can be translated to many formats including HTML, PDF,
      EPUB, man page.

      AsciiDoc is highly configurable: both the AsciiDoc source file syntax and
      the backend output markups (which can be almost any type of SGML/XML
      markup) can be customized and extended by the user.
    '';
    homepage = "http://www.methods.co.nz/asciidoc/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
