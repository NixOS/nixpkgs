{ stdenv, fetchurl, skktools }:

let
  # kana to kanji
  small = fetchurl {
    url = "https://raw.githubusercontent.com/skk-dev/dict/f61be71246602a49e9f05ded6ac4f9f82031a521/SKK-JISYO.S";
    sha256 = "15kp4iwz58fp1zg0i13x7w9wwm15v8n2hhm0nf2zsl7az5mn5yi4";
  };
  medium = fetchurl {
    url = "https://raw.githubusercontent.com/skk-dev/dict/f61be71246602a49e9f05ded6ac4f9f82031a521/SKK-JISYO.M";
    sha256 = "1vhagixhrp9lq5x7dldxcanhznawazp00xivpp1z52kx10lnkmv0";
  };
  large = fetchurl {
    url = "https://raw.githubusercontent.com/skk-dev/dict/f61be71246602a49e9f05ded6ac4f9f82031a521/SKK-JISYO.L";
    sha256 = "07cv0j95iajkr48j4ln411vnhl3z93yx96zjc03bgs10dbpagaaz";
  };

  # english to japanese
  edict = fetchurl {
    url = "https://raw.githubusercontent.com/skk-dev/dict/f61be71246602a49e9f05ded6ac4f9f82031a521/SKK-JISYO.edict";
    sha256 = "18k8z1wkgwgfwbs6sylf39h1nc1p5l2b00h7mfjlb8p91plkb45w";
  };
  # misc
  assoc = fetchurl {
    url = "https://raw.githubusercontent.com/skk-dev/dict/f61be71246602a49e9f05ded6ac4f9f82031a521/SKK-JISYO.assoc";
    sha256 = "12d6xpp1bfin9nwl35ydl5yc6vx0qpwhxss0khi19n1nsbyqnixm";
  };
in

stdenv.mkDerivation rec {
  name = "skk-dicts-unstable-${version}";
  version = "2017-10-26";
  srcs = [ small medium large edict assoc ];
  nativeBuildInputs = [ skktools ];

  phases = [ "installPhase" ];
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
      iconv -f EUC-JP -t UTF-8 $src |\
        ${skktools}/bin/skkdic-expr2 >> $dst
    done

    # combine .L .edict and .assoc for convenience
    dst=$out/share/SKK-JISYO.combined
    echo ";;; -*- coding: utf-8 -*-" > $dst
    ${skktools}/bin/skkdic-expr2 \
      $out/share/$(dictname ${large}) + \
      $out/share/$(dictname ${edict}) + \
      $out/share/$(dictname ${assoc}) >> $dst
  '';

  meta = {
    description = "A collection of standard SKK dictionaries";
    longDescription = ''
      This package provides a collection of standard kana-to-kanji
      dictionaries for the SKK Japanese input method.
    '';
    homepage = https://github.com/skk-dev/dict;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ yuriaisaka ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
