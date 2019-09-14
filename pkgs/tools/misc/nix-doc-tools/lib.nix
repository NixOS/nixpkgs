{ lib, writeText, docbook_xsl_ns, fetchFromGitHub, stdenvNoCC
, nodePackages, runCommand, docbook5, documentation-highlighter
, libxml2, libxslt, zip, xmlformat, docbook-index, coreutils
, jing, xmloscopy, findutils }:
rec {
  version = lib.version;

  epub-overrides = ./overrides.css;

  epub-xsl = writeText "epub.xsl" ''
    <?xml version='1.0'?>
    <xsl:stylesheet
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      version="1.0">
      <xsl:import href="${docbook_xsl_ns}/xml/xsl/docbook/epub/docbook.xsl" />
      <xsl:import href="${./parameters.xsl}"/>
    </xsl:stylesheet>
  '';

  chunk-xhtml-xsl = writeText "chunk-xhtml.xsl" ''
    <?xml version='1.0'?>
    <xsl:stylesheet
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      version="1.0">
      <xsl:import href="${docbook_xsl_ns}/xml/xsl/docbook/xhtml/chunkfast.xsl" />
      <xsl:import href="${./parameters.xsl}"/>
    </xsl:stylesheet>
  '';

  onepage-xhtml-xsl = writeText "onepage-xhtml.xsl" ''
    <?xml version='1.0'?>
    <xsl:stylesheet
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      version="1.0">
      <xsl:import href="${docbook_xsl_ns}/xml/xsl/docbook/xhtml/docbook.xsl" />
      <xsl:import href="${./parameters.xsl}"/>
    </xsl:stylesheet>
  '';

  elasticlunr = fetchFromGitHub {
    owner = "weixsong";
    repo = "elasticlunr.js";
    # 2019-07-04
    rev = "c468634165ecace8281f487a8f0e301a6880473b";
    sha256 = "1kn4v96hjs2q4y0fqgj8k1xmbh5291s351r92x9w17j6g9wqj7li";
  };

  styles = stdenvNoCC.mkDerivation {
    name = "doc-styles";
    src = ./styles;

    buildInputs = with nodePackages; [
      less
      svgo
    ];

    buildPhase = ''
      # Skip the source svg files
      rm *.src.svg

      # Optimize svg files
      for f in *.svg; do svgo $f; done

      # Embed svg files in svg.less
      for f in *.svg; do
        token=''${f^^}
        token=''${token//[^A-Z]/_}
        token=SVG_''${token/%_SVG/}
        substituteInPlace svg.less --replace "@$token" "'$(cat $f)'"
      done

      lessc index.less $out
    '';

    dontInstall = true;
  };

  standard-tools = runCommand "standard-doc-support" {}
  ''
    mkdir result
    (
      cd result
      ln -s ${docbook5}/xml/rng/docbook/docbook.rng ./docbook.rng
      ln -s ${docbook_xsl_ns}/xml/xsl ./xsl
      ln -s ${epub-xsl} ./epub.xsl
      ln -s ${chunk-xhtml-xsl} ./chunk-xhtml.xsl
      ln -s ${onepage-xhtml-xsl} ./onepage-xhtml.xsl
      ln -s ${./xmlformat.conf} ./xmlformat.conf
      echo -n "${version}" > ./version

      mkdir -p ./web/highlightjs
	    cp ${documentation-highlighter}/highlight.pack.js ./web/highlightjs/
	    cp ${documentation-highlighter}/LICENSE ./web/highlightjs/
	    cp ${documentation-highlighter}/mono-blue.css ./web/highlightjs/
	    cp ${documentation-highlighter}/loader.js ./web/highlightjs/
      cp ${./docs.js} ./web/docs.js
      cp -r ${elasticlunr}/elasticlunr.min.js ./web/elasticlunr.min.js
      cp ${styles} ./web/style.css
      cp ${epub-overrides} ./web/overrides.css
      mkdir -p ./web/images/callouts/
      cp ${docbook_xsl_ns}/xml/xsl/docbook/images/callouts/*.svg ./web/images/callouts/

      chmod -R u+w ./web
    )
    mv result $out
  '';

  toolbox = rec {
    build = [ libxml2 libxslt zip xmlformat docbook-index coreutils ];
    dev = build ++ [ jing xmloscopy findutils ];
  };
}
