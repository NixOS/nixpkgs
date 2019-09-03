{ lib, callPackage, buildEnv, writeShellScriptBin, docbook_xsl_ns, stdenvNoCC }:
{
  name
  , src
  , generated-files ? []
  , root-file-name ? "manual.xml"
  , combined-file-name ? "manual-full.xml"
  , nativeBuildInputs ? []
  , preBuild ? ""
}:
let
  doclib = callPackage ./lib.nix {};

  generated = buildEnv {
    name = "docs-tooling-${name}";
    paths = [ doclib.standard-tools ] ++ generated-files;
  };

  tools.build = writeShellScriptBin "docs-build" ''
    PATH=${lib.makeBinPath (doclib.toolbox.build ++ nativeBuildInputs)}

    set -eux

    scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
    function finish {
      rm -rf "$scratch"
    }
    trap finish EXIT

    input="${root-file-name}"
    output="$1"

    rm -f ./generated
    ln -s ${generated} ./generated

    (
      ${preBuild}
    )

    xmllint --nonet \
      --xinclude \
      --noxincludenode "$input" \
      --output "${combined-file-name}"

    # Build the HTML docs
    mkdir -p "$output/share/doc/${name}/html"
    cp -r ./generated/web/* "$output/share/doc/${name}/html"
    chmod -R u+w "$output/share/doc/${name}/html"
    xsltproc \
      --nonet --xinclude \
      --output "$output/share/doc/${name}/html/" \
      ./generated/chunk-xhtml.xsl \
      ${combined-file-name}

    # Build the EPUB docs
    mkdir -p "$scratch/epub/OEBPS"
    xsltproc --nonet \
      --output "$scratch/epub/" \
      ./generated/epub.xsl \
      ${combined-file-name}

    cp ${doclib.epub-overrides} "$scratch/epub/OEBPS/override.css"
    mkdir -p "$scratch/epub/OEBPS/images/callouts/"
    cp ${docbook_xsl_ns}/xml/xsl/docbook/images/callouts/*.svg "$scratch/epub/OEBPS/images/callouts/"

    echo "application/epub+zip" > "$scratch/mimetype"
    zip -0Xq "$scratch/output.epub" "$scratch/mimetype"
    rm "$scratch/mimetype"
    (
      cd "$scratch/epub/"
      zip -Xr9D "$scratch/output.epub" *
    )
    mv "$scratch/output.epub" "$output/share/doc/${name}/${name}.epub"

    mkdir -p $output/nix-support/
    echo "doc manual $output/share/doc/${name}/html index.html" >> $output/nix-support/hydra-build-products
    echo "doc manual $output/share/doc/${name}/${name}.epub ${name}.epub" >> $output/nix-support/hydra-build-products
  '';
in stdenvNoCC.mkDerivation {
  inherit name src;

  buildInputs = [ tools.build ];

  buildPhase = ''
    ls -la
    docs-build $out
  '';

  installPhase = ":";
}
