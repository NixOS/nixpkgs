{ lib
, stdenv
, graphviz
, imagemagick
, linux_latest
, makeFontsConf
, perl
, python3
, which
, fetchpatch
}:

stdenv.mkDerivation {
  pname = "linux-kernel-latest-htmldocs";

  inherit (linux_latest) version src;

  patches = [
    # docutils 0.21 has removed nodes.reprunicode
    # fixes the `AttributeError` thrown when building docs.
    (fetchpatch {
      name = "docutils_fix.patch";
      url = "https://lore.kernel.org/linux-doc/faf5fa45-2a9d-4573-9d2e-3930bdc1ed65@gmail.com/raw";
      hash = "sha256-JuV1B/8iDysbH0tl+wr/rdXvoC34uUq25ejMFmD0hio=";
    })
  ];

  postPatch = ''
    patchShebangs \
      Documentation/sphinx/parse-headers.pl \
      scripts/{get_abi.pl,get_feat.pl,kernel-doc,sphinx-pre-install} \
      tools/net/ynl/ynl-gen-rst.py
  '';

  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ ];
  };

  nativeBuildInputs = [
    graphviz
    imagemagick
    perl
    python3.pkgs.sphinx
    python3.pkgs.sphinx-rtd-theme
    python3.pkgs.pyyaml
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

  meta = {
    description = "Linux kernel html documentation";
    homepage = "https://www.kernel.org/doc/htmldocs/";
    platforms = lib.platforms.linux;
    inherit (linux_latest.meta) license;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
