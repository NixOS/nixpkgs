{ pkgs ? (import ../.. {}), nixpkgs ? { }}:
let
  locationsXml = import ./lib-function-locations.nix { inherit pkgs nixpkgs; };
  functionDocs = import ./lib-function-docs.nix { inherit locationsXml pkgs; };
  version = pkgs.lib.version;

  epub-xsl = pkgs.writeText "epub.xsl" ''
    <?xml version='1.0'?>
    <xsl:stylesheet
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      version="1.0">
      <xsl:import href="${pkgs.docbook_xsl_ns}/xml/xsl/docbook/epub/docbook.xsl" />
      <xsl:import href="${./parameters.xsl}"/>
    </xsl:stylesheet>
  '';

  chunk-xhtml-xsl = pkgs.writeText "chunk-xhtml.xsl" ''
    <?xml version='1.0'?>
    <xsl:stylesheet
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      version="1.0">
      <xsl:import href="${pkgs.docbook_xsl_ns}/xml/xsl/docbook/xhtml/chunkfast.xsl" />
      <xsl:import href="${./parameters.xsl}"/>
    </xsl:stylesheet>
  '';

  onepage-xhtml-xsl = pkgs.writeText "onepage-xhtml.xsl" ''
    <?xml version='1.0'?>
    <xsl:stylesheet
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      version="1.0">
      <xsl:import href="${pkgs.docbook_xsl_ns}/xml/xsl/docbook/xhtml/docbook.xsl" />
      <xsl:import href="${./parameters.xsl}"/>
    </xsl:stylesheet>
  '';

  elasticlunr = pkgs.fetchFromGitHub {
    owner = "weixsong";
    repo = "elasticlunr.js";
    # 2019-07-04
    rev = "c468634165ecace8281f487a8f0e301a6880473b";
    sha256 = "1kn4v96hjs2q4y0fqgj8k1xmbh5291s351r92x9w17j6g9wqj7li";
  };

  styles = pkgs.stdenvNoCC.mkDerivation {
    name = "doc-styles";
    src = ./styles;

    buildInputs = with pkgs.nodePackages; [
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

  standard-tools = pkgs.runCommand "standard-doc-support" {}
  ''
    mkdir result
    (
      cd result
      ln -s ${pkgs.docbook5}/xml/rng/docbook/docbook.rng ./docbook.rng
      ln -s ${pkgs.docbook_xsl_ns}/xml/xsl ./xsl
      ln -s ${epub-xsl} ./epub.xsl
      ln -s ${chunk-xhtml-xsl} ./chunk-xhtml.xsl
      ln -s ${onepage-xhtml-xsl} ./onepage-xhtml.xsl

      ln -s ${../../nixos/doc/xmlformat.conf} ./xmlformat.conf
      ln -s ${pkgs.documentation-highlighter} ./highlightjs

      ln -s ${./search.js} ./search.js
      ln -s ${elasticlunr} ./elasticlunr

      echo -n "${version}" > ./version

      ln -s ${styles} ./style.css
    )
    mv result $out
  '';
in pkgs.buildEnv {
  name = "docs-tooling";
  paths = [ standard-tools locationsXml functionDocs ];
}
