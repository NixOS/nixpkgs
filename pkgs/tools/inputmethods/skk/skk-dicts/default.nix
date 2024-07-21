{ lib, stdenv, fetchurl, iconv, skktools }:

let
  # kana to kanji
  small = fetchurl {
    url = "https://raw.githubusercontent.com/skk-dev/dict/8b35d07a7d2044d48b063d2774d9f9d00bb7cb48/SKK-JISYO.S";
    sha256 = "11cjrc8m99hj4xpl2nvzxanlswpapi92vmgk9d6yimdz0jidb6cq";
  };
  medium = fetchurl {
    url = "https://raw.githubusercontent.com/skk-dev/dict/8b35d07a7d2044d48b063d2774d9f9d00bb7cb48/SKK-JISYO.M";
    sha256 = "0pwjp9qjmn9sq6zc0k6632l7dc2dbjn45585ibckvvl9iwfqqxdp";
  };
  large = fetchurl {
    url = "https://raw.githubusercontent.com/skk-dev/dict/8b35d07a7d2044d48b063d2774d9f9d00bb7cb48/SKK-JISYO.L";
    sha256 = "0ps0a7sbkryd6hxvphq14i7g5wci4gvr0vraac8ia2ww67a2xbyc";
  };

  # english to japanese
  edict = fetchurl {
    url = "https://raw.githubusercontent.com/skk-dev/dict/8b35d07a7d2044d48b063d2774d9f9d00bb7cb48/SKK-JISYO.edict";
    sha256 = "1vrwnq0vvjn61nijbln6wfinqg93802d2a8d4ad82n692v83b1li";
  };
  # misc
  assoc = fetchurl {
    url = "https://raw.githubusercontent.com/skk-dev/dict/8b35d07a7d2044d48b063d2774d9f9d00bb7cb48/SKK-JISYO.assoc";
    sha256 = "1smcbyv6srrhnpl7ic9nqds9nz3g2dgqngmhzkrdlwmvcpvakp1v";
  };
in

stdenv.mkDerivation {
  pname = "skk-dicts-unstable";
  version = "2020-03-24";
  srcs = [ small medium large edict assoc ];
  nativeBuildInputs = [ iconv skktools ];

  strictDeps = true;

  dontUnpack = true;

  installPhase = ''
    function dictname() {
      src=$1
      name=$(basename $src)          # remove dir name
      dict=$(echo $name | cut -b34-) # remove sha256 prefix
      echo $dict
    }
    mkdir -p $out/share

    for src in $srcs; do
      dst=$out/share/$(dictname $src)
      echo ";;; -*- coding: utf-8 -*-" > $dst  # libskk requires this on the first line
      iconv -f EUC-JP -t UTF-8 $src | skkdic-expr2 >> $dst
    done

    # combine .L .edict and .assoc for convenience
    dst=$out/share/SKK-JISYO.combined
    echo ";;; -*- coding: utf-8 -*-" > $dst
    skkdic-expr2 \
      $out/share/$(dictname ${large}) + \
      $out/share/$(dictname ${edict}) + \
      $out/share/$(dictname ${assoc}) >> $dst
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Collection of standard SKK dictionaries";
    longDescription = ''
      This package provides a collection of standard kana-to-kanji
      dictionaries for the SKK Japanese input method.
    '';
    homepage = "https://github.com/skk-dev/dict";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yuriaisaka ];
    platforms = platforms.all;
  };
}
