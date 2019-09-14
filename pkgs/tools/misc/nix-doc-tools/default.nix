{ lib, callPackage, buildEnv, writeShellScriptBin, docbook-xsl-ns, stdenvNoCC }:
{
  name
  , src
  , generated-files ? []
  , root-file-name ? "manual.xml"
  , combined-file-name ? "manual-full.xml"
  , nativeBuildInputs ? []
  , preBuild ? ":"
  , nix-shell ? false
}:
let
  doclib = callPackage ./lib.nix {};

  generated = buildEnv {
    name = "docs-tooling-${name}";
    paths = [ doclib.standard-tools ] ++ generated-files;
  };

  preamble = ''
    set -eu

    # The scripts will be noisy when used with `DEBUG=1 docs-*`
    # or when they are part of a build (not in nix-shell).
    if [[ -n ''${DEBUG:-} || -z ''${IN_NIX_SHELL:-} ]]; then
      set -x
      export RUST_BACKTRACE=1
    fi
  '';

  # a `docs-generate` command special for a nix-shell, since it
  # uses `nix-build` instead of hard-coding a path.
  tools.nix-shell-generate = writeShellScriptBin "docs-generate" ''
    ${preamble}

    nix-shell ${toString src} --run "docs-generate"
  '';

  tools.generate = writeShellScriptBin "docs-generate" ''
    PATH=${lib.makeBinPath (doclib.toolbox.build ++ nativeBuildInputs)}

    ${preamble}

    scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
    function finish {
      rm -rf "$scratch"
    }
    trap finish EXIT

    rm -f ./generated
    ln -s ${generated} ./generated

    (
      ${preBuild}
    )
  '';

  tools.validate = writeShellScriptBin "docs-validate" ''
    PATH=${lib.makeBinPath (doclib.toolbox.dev)}

    ${preamble}

    if [ ! -d ./generated ]; then
      echo "Please run «docs-generate»"
    fi

    xmllint --nonet \
      --xinclude \
      --noxincludenode "${root-file-name}" \
      --output "${combined-file-name}"

     if jing ./generated/docbook.rng ${combined-file-name}; then
       echo "OK!"
     else
       echo "Not OK. Try «docs-debug» if you need help."
       exit 1
     fi
   '';

   tools.format = writeShellScriptBin "docs-format" ''
    PATH=${lib.makeBinPath (doclib.toolbox.dev)}

    ${preamble}

	  find "${toString src}" -name '*.xml' -type f -print0  \
      | xargs -0 -I{} -n1 \
        xmlformat --config-file '${./xmlformat.conf}' -i {}
   '';

  tools.debug = writeShellScriptBin "docs-debug" ''
    PATH=${lib.makeBinPath (doclib.toolbox.dev)}

    ${preamble}

    if [ ! -d ./generated ]; then
      echo "Please run «docs-generate»"
    fi

    xmloscopy --docbook5 ${root-file-name} ${combined-file-name}
  '';

  tools.build = writeShellScriptBin "docs-build" ''
    PATH=${lib.makeBinPath (doclib.toolbox.build ++ nativeBuildInputs)}

    ${preamble}

    scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
    function finish {
      rm -rf "$scratch"
    }
    trap finish EXIT

    input="${root-file-name}"

    if (( $# < 1 )); then
      echo "Usage: docs-build <output>"
      exit 2
    fi

    output="$1"

    if [ ! -d ./generated ]; then
      echo "Please run «docs-generate»"
      exit 1
    fi

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

    docbook-index \
      ./${combined-file-name} \
      $output/share/doc/${name}/html/ \
      $output/share/doc/${name}/html/index.js

    # Build the EPUB docs
    mkdir -p "$scratch/epub/OEBPS"
    xsltproc --nonet \
      --output "$scratch/epub/" \
      ./generated/epub.xsl \
      ${combined-file-name}

    cp ./generated/web/style.css "$scratch/epub/OEBPS/style.css"
    cp ${doclib.epub-overrides} "$scratch/epub/OEBPS/override.css"
    mkdir -p "$scratch/epub/OEBPS/images/callouts/"
    cp ${docbook-xsl-ns}/xml/xsl/docbook/images/callouts/*.svg "$scratch/epub/OEBPS/images/callouts/"

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

  buildInputs = [ tools.build ] ++ (if nix-shell then [
    tools.nix-shell-generate tools.validate tools.debug tools.format
  ] else [
    tools.generate
  ]) ;

  buildPhase = ''
    docs-generate
    docs-build $out
  '';

  # Prints a preamble for direct help.
  # FIXME: Add link to the manual html page for more details about authoring.
  shellHook = ''
    export IN_NIXPKGS_DOCS_SHELL+=1
    if (( IN_NIXPKGS_DOCS_SHELL == 1 )); then
    cat <<-EOF
      Quick tips:

       * Use docs-generate to generate dynamic content.
       * Use docs-build to build the documentation.
       * Use docs-validate to validate and debug issues.

      Look at the manual for more information about authoring.
       -> https://nixos.org/nixpkgs/manual/chap-contributing.html
    EOF
    fi
  '';

  installPhase = ":";
}
