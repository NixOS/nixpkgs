{
  fetchurl,
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  autoreconfHook,
  installShellFiles,
  enableStandardFeatures ? false,
  sourceHighlight,
  highlight,
  pygments,
  graphviz,
  texliveMinimal,
  dblatexFull,
  libxslt,
  w3m,
  lynx,
  imagemagick,
  lilypond,
  libxml2,
  docbook_xml_dtd_45,
  docbook_xsl_ns,
  docbook_xsl,
  fop,
  epubcheck,
  gnused,
  coreutils,

  # if true, enable all the below filters and backends
  enableExtraPlugins ? false,

  # unzip is needed to extract filter and backend plugins
  unzip,
  # filters
  enableDitaaFilter ? false,
  jre,
  enableMscgenFilter ? false,
  mscgen,
  enableDiagFilter ? false,
  blockdiag,
  seqdiag,
  actdiag,
  nwdiag,
  enableQrcodeFilter ? false,
  qrencode,
  enableMatplotlibFilter ? false,
  matplotlib,
  numpy,
  enableAafigureFilter ? false,
  aafigure,
  recursive-pth-loader,
  # backends
  enableDeckjsBackend ? false,
  enableOdfBackend ? false,

  # java is problematic on some platforms, where it is unfree
  enableJava ? true,

  buildPackages,
}:

let

  _enableDitaaFilter = (enableExtraPlugins && enableJava) || enableDitaaFilter;
  _enableMscgenFilter = enableExtraPlugins || enableMscgenFilter;
  _enableDiagFilter = enableExtraPlugins || enableDiagFilter;
  _enableQrcodeFilter = enableExtraPlugins || enableQrcodeFilter;
  _enableMatplotlibFilter = enableExtraPlugins || enableMatplotlibFilter;
  _enableAafigureFilter = enableExtraPlugins || enableAafigureFilter;
  _enableDeckjsBackend = enableExtraPlugins || enableDeckjsBackend;
  _enableOdfBackend = enableExtraPlugins || enableOdfBackend;

  #
  # texlive environment
  #
  texlive = texliveMinimal.withPackages (ps: [ ps.dvipng ]);

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

  # there are no archives or tags, using latest commit in master branch as per 2013-09-22
  matplotlibFilterSrc =
    let
      commit = "75f0d009629f93f33fab04b83faca20cc35dd358";
    in
    fetchurl {
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
python3.pkgs.buildPythonApplication rec {
  pname =
    "asciidoc"
    + lib.optionalString enableStandardFeatures "-full"
    + lib.optionalString enableExtraPlugins "-with-plugins";
  version = "10.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asciidoc-py";
    repo = "asciidoc-py";
    rev = version;
    hash = "sha256-td3C7xTWfSzdo9Bbz0dHW2oPaCQYmUE9H2sUFfg5HH0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
    unzip
  ];

  # install filters early, so their shebangs are patched too
  postPatch = ''
    mkdir -p "$out/etc/asciidoc/filters"
    mkdir -p "$out/etc/asciidoc/backends"
  ''
  + lib.optionalString _enableDitaaFilter ''
    echo "Extracting ditaa filter"
    unzip -d "$out/etc/asciidoc/filters/ditaa" "${ditaaFilterSrc}"
    sed -i -e "s|java -jar|${jre}/bin/java -jar|" \
        "$out/etc/asciidoc/filters/ditaa/ditaa2img.py"
  ''
  + lib.optionalString _enableMscgenFilter ''
    echo "Extracting mscgen filter"
    unzip -d "$out/etc/asciidoc/filters/mscgen" "${mscgenFilterSrc}"
    sed -i -e "s|filter-wrapper.py mscgen|filter-wrapper.py ${mscgen}/bin/mscgen|" \
        "$out/etc/asciidoc/filters/mscgen/mscgen-filter.conf"
  ''
  + lib.optionalString _enableDiagFilter ''
    echo "Extracting diag filter"
    unzip -d "$out/etc/asciidoc/filters/diag" "${diagFilterSrc}"
    sed -i \
        -e "s|filter='blockdiag|filter=\'${blockdiag}/bin/blockdiag|" \
        -e "s|filter='seqdiag|filter=\'${seqdiag}/bin/seqdiag|" \
        -e "s|filter='actdiag|filter=\'${actdiag}/bin/actdiag|" \
        -e "s|filter='nwdiag|filter=\'${nwdiag}/bin/nwdiag|" \
        -e "s|filter='packetdiag|filter=\'${nwdiag}/bin/packetdiag|" \
        "$out/etc/asciidoc/filters/diag/diag-filter.conf"
  ''
  + lib.optionalString _enableQrcodeFilter ''
    echo "Extracting qrcode filter"
    unzip -d "$out/etc/asciidoc/filters/qrcode" "${qrcodeFilterSrc}"
    sed -i -e "s|systemcmd('qrencode|systemcmd('${qrencode}/bin/qrencode|" \
        "$out/etc/asciidoc/filters/qrcode/qrcode2img.py"
  ''
  + lib.optionalString _enableMatplotlibFilter ''
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
  ''
  + lib.optionalString _enableAafigureFilter ''
    echo "Extracting aafigure filter"
    unzip -d "$out/etc/asciidoc/filters/aafigure" "${aafigureFilterSrc}"
    # Add aafigure to sys.path (and it needs recursive-pth-loader)
    pth_loader_path="$(toPythonPath ${recursive-pth-loader})"
    aafigure_path="$(toPythonPath ${aafigure})"
    sed -i "/^import.*sys/asys.path.append(\"$pth_loader_path\"); sys.path.append(\"$aafigure_path\"); import sitecustomize" \
        "$out/etc/asciidoc/filters/aafigure/aafig2img.py"
  ''
  + lib.optionalString _enableDeckjsBackend ''
    echo "Extracting deckjs backend"
    unzip -d "$out/etc/asciidoc/backends/deckjs" "${deckjsBackendSrc}"
  ''
  + lib.optionalString _enableOdfBackend ''
    echo "Extracting odf backend (odt + odp)"
    unzip -d "$out/etc/asciidoc/backends/odt" "${odtBackendSrc}"
    unzip -d "$out/etc/asciidoc/backends/odp" "${odpBackendSrc}"
    # The odt backend has a TODO note about removing this hardcoded path, but
    # the odp backend already has that fix. Copy it here until fixed upstream.
    sed -i "s|'/etc/asciidoc/backends/odt/asciidoc.ott'|os.path.dirname(__file__),'asciidoc.ott'|" \
        "$out/etc/asciidoc/backends/odt/a2x-backend.py"
  ''
  + (
    if enableStandardFeatures then
      ''
        sed -e "s|dot|${graphviz}/bin/dot|g" \
            -e "s|neato|${graphviz}/bin/neato|g" \
            -e "s|twopi|${graphviz}/bin/twopi|g" \
            -e "s|circo|${graphviz}/bin/circo|g" \
            -e "s|fdp|${graphviz}/bin/fdp|g" \
            -i "asciidoc/resources/filters/graphviz/graphviz2png.py"

        sed -e "s|run('latex|run('${texlive}/bin/latex|g" \
            -e "s|cmd = 'dvipng'|cmd = '${texlive}/bin/dvipng'|g" \
            -e "s|cmd = 'dvisvgm'|cmd = '${texlive}/bin/dvisvgm'|g" \
            -i "asciidoc/resources/filters/latex/latex2img.py"

        sed -e "s|run('abc2ly|run('${lilypond}/bin/abc2ly|g" \
            -e "s|run('lilypond|run('${lilypond}/bin/lilypond|g" \
            -e "s|run('convert|run('${imagemagick.out}/bin/convert|g" \
            -i "asciidoc/resources/filters/music/music2png.py"

        sed -e 's|filter="source-highlight|filter="${sourceHighlight}/bin/source-highlight|' \
            -e 's|filter="highlight|filter="${highlight}/bin/highlight|' \
            -e 's|filter="pygmentize|filter="${pygments}/bin/pygmentize|' \
            -i "asciidoc/resources/filters/source/source-highlight-filter.conf"

        # ENV is custom environment passed to programs that a2x invokes. Here we
        # use it to work around an impurity in the tetex package; tetex tools
        # cannot find their neighbours (e.g. pdflatex doesn't find mktextfm).
        # We can remove PATH= when those impurities are fixed.
        # TODO: Is this still necessary when using texlive?
        sed -e "s|^ENV =.*|ENV = dict(XML_CATALOG_FILES='${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml ${docbook_xsl_ns}/xml/xsl/docbook/catalog.xml ${docbook_xsl}/xml/xsl/docbook/catalog.xml', PATH='${
          lib.makeBinPath [
            texlive
            coreutils
            gnused
          ]
        }', **(dict(filter(lambda v: v[0] == 'SOURCE_DATE_EPOCH', os.environ.items()))))|" \
            -e "s|^ASCIIDOC =.*|ASCIIDOC = '$out/bin/asciidoc'|" \
            -e "s|^XSLTPROC =.*|XSLTPROC = '${libxslt.bin}/bin/xsltproc'|" \
            -e "s|^DBLATEX =.*|DBLATEX = '${dblatexFull}/bin/dblatex'|" \
            ${lib.optionalString enableJava ''-e "s|^FOP =.*|FOP = '${fop}/bin/fop'|"''} \
            -e "s|^W3M =.*|W3M = '${w3m}/bin/w3m'|" \
            -e "s|^LYNX =.*|LYNX = '${lynx}/bin/lynx'|" \
            -e "s|^XMLLINT =.*|XMLLINT = '${libxml2.bin}/bin/xmllint'|" \
            -e "s|^EPUBCHECK =.*|EPUBCHECK = '${epubcheck}/bin/epubcheck'|" \
            -i asciidoc/a2x.py
      ''
    else
      ''
        sed -e "s|^ENV =.*|ENV = dict(XML_CATALOG_FILES='${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml ${docbook_xsl_ns}/xml/xsl/docbook/catalog.xml ${docbook_xsl}/xml/xsl/docbook/catalog.xml', **(dict(filter(lambda v: v[0] == 'SOURCE_DATE_EPOCH', os.environ.items()))))|" \
            -e "s|^XSLTPROC =.*|XSLTPROC = '${libxslt.bin}/bin/xsltproc'|" \
            -e "s|^XMLLINT =.*|XMLLINT = '${libxml2.bin}/bin/xmllint'|" \
            -i asciidoc/a2x.py
      ''
  )
  + ''
    # Fix tests
    for f in $(grep -R --files-with-matches "2002-11-25") ; do
      substituteInPlace $f --replace "2002-11-25" "1980-01-02"
      substituteInPlace $f --replace "00:37:42" "00:00:00"
    done
  ''
  + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    # We want to use asciidoc from the build platform to build the documentation.
    substituteInPlace Makefile.in \
      --replace "python3 -m asciidoc.a2x" "${buildPackages.asciidoc}/bin/a2x"
  '';

  build-system = with python3.pythonOnBuildForHost.pkgs; [ setuptools ];

  postBuild = ''
    make manpages
  '';

  postInstall = ''
    installManPage doc/asciidoc.1 doc/a2x.1 doc/testasciidoc.1
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytest
    pytest-mock
  ];

  checkPhase = ''
    runHook preCheck

    make test

    runHook postCheck
  '';

  meta = {
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
    sourceProvenance = [
      lib.sourceTypes.fromSource
    ]
    ++ lib.optional _enableDitaaFilter lib.sourceTypes.binaryBytecode;
    homepage = "https://asciidoc-py.github.io/";
    changelog = "https://github.com/asciidoc-py/asciidoc-py/blob/${version}/CHANGELOG.adoc";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      bjornfor
      dotlambda
    ];
  };
}
