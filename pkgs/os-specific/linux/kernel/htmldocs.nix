{ lib
, stdenv
, graphviz
, imagemagick
, linux_latest
, makeFontsConf
, perl
, python3
, sphinx
, which
}:

let
  py = python3.override {
    packageOverrides = final: prev: rec {
      docutils_old = prev.docutils.overridePythonAttrs (oldAttrs: rec {
        version = "0.16";
        src = final.fetchPypi {
          pname = "docutils";
          inherit version;
          sha256 = "sha256-wt46YOnn0Hvia38rAMoDCcIH4GwQD5zCqUkx/HWkePw=";
        };
      });

      sphinx = (prev.sphinx.override rec {
        alabaster = prev.alabaster.override { inherit pygments; };
        docutils = docutils_old;
        pygments = prev.pygments.override { docutils = docutils_old; };
      }).overridePythonAttrs {
        # fails due to duplicated packages
        doCheck = false;
      };

      sphinx-rtd-theme = prev.sphinx-rtd-theme.override {
        inherit sphinx;
        docutils = docutils_old;
      };
    };
  };
in

stdenv.mkDerivation {
  pname = "linux-kernel-latest-htmldocs";

  inherit (linux_latest) version src;

  postPatch = ''
    patchShebangs \
      Documentation/sphinx/parse-headers.pl \
      scripts/{get_abi.pl,get_feat.pl,kernel-doc,sphinx-pre-install}
  '';

  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ ];
  };

  nativeBuildInputs = [
    graphviz
    imagemagick
    perl
    py.pkgs.sphinx
    py.pkgs.sphinx-rtd-theme
    which
  ];

  preBuild = ''
    export XDG_CACHE_HOME="$(mktemp -d)"
  '';

  makeFlags = [ "htmldocs" ];

  installPhase = ''
    mkdir -p $out/share/doc
    mv Documentation/output $out/share/doc/linux-doc
    cp -r Documentation/* $out/share/doc/linux-doc/
  '';

  meta = with lib; {
    description = "Linux kernel html documentation";
    homepage = "https://www.kernel.org/doc/htmldocs/";
    platforms = platforms.linux;
    inherit (linux_latest.meta) license;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
