{ stdenv, fetchurl, pkgconfig, cmake, intltool, gettext
, libxml2, enchant2, isocodes, icu, libpthreadstubs
, pango, cairo, libxkbfile, libXau, libXdmcp, libxkbcommon
, dbus, gtk2, gtk3, qt4, extra-cmake-modules
, xkeyboard_config, pcre, libuuid
, withPinyin ? true
, fetchFromGitLab
}:

let
  # releases at http://download.fcitx-im.org/fcitx/${name}_dict.tar.xz
  # contains all data but if we want to compile from source, we need to
  # fetch them ourselves
  # to update the urls and where to unpack these, look into the
  # src/module/*/data/CMakeLists.txt files
  # fcitx_download tgt_name url output)
  dicts = let SPELL_EN_DICT_VER="20121020"; in fetchurl {
      url = "http://download.fcitx-im.org/data/en_dict-${SPELL_EN_DICT_VER}.tar.gz";
      sha256 = "1svcb97sq7nrywp5f2ws57cqvlic8j6p811d9ngflplj8xw5sjn4";
  };
  table = fetchurl {
      url = http://download.fcitx-im.org/data/table.tar.gz;
      sha256 = "1dw7mgbaidv3vqy0sh8dbfv8631d2zwv5mlb7npf69a1f8y0b5k1";
  };
  pystroke-data = let PY_STROKE_VER="20121124"; in fetchurl {
      url = "http://download.fcitx-im.org/data/py_stroke-${PY_STROKE_VER}.tar.gz";
      sha256 = "0j72ckmza5d671n2zg0psg7z9iils4gyxz7jgkk54fd4pyljiccf";
  };
  pytable-data = let PY_TABLE_VER="20121124"; in fetchurl {
      url = "http://download.fcitx-im.org/data/py_table-${PY_TABLE_VER}.tar.gz";
      sha256 = "011cg7wssssm6hm564cwkrrnck2zj5rxi7p9z5akvhg6gp4nl522";
  };
  pinyin-data = fetchurl {
      url = http://download.fcitx-im.org/data/pinyin.tar.gz;
      sha256 = "1qfq5dy4czvd1lvdnxzyaiir9x8b1m46jjny11y0i33m9ar2jf2q";
  };
in
stdenv.mkDerivation rec {
  pname = "fcitx";
  version = "4.2.9.6";

  src = fetchFromGitLab {
    owner = "fcitx";
    repo = "fcitx";
    rev = version;
    sha256 = "0j5vaf930lb21gx4h7z6mksh1fazqw32gajjjkyir94wbmml9n3s";
  };

  # put data at the correct locations else cmake tries to fetch them,
  # which fails in sandboxed mode
  prePatch = ''
    cp ${dicts} src/module/spell/dict/$(stripHash ${dicts})
    cp ${table} src/im/table/data/$(stripHash ${table})
  ''
  + stdenv.lib.optionalString withPinyin ''
    cp ${pystroke-data} src/module/pinyin-enhance/data/$(stripHash ${pystroke-data})
    cp ${pytable-data} src/module/pinyin-enhance/data/$(stripHash ${pytable-data})
    cp ${pinyin-data} src/im/pinyin/data/$(stripHash ${pinyin-data})
  ''
  ;

  patches = [ ./find-enchant-lib.patch ];

  postPatch = ''
    substituteInPlace src/frontend/qt/CMakeLists.txt \
      --replace $\{QT_PLUGINS_DIR} $out/lib/qt4/plugins

    patchShebangs cmake/
  '';

  nativeBuildInputs = [ cmake extra-cmake-modules intltool pkgconfig pcre ];

  buildInputs = [
    xkeyboard_config enchant2 gettext isocodes icu libpthreadstubs libXau libXdmcp libxkbfile
    libxkbcommon libxml2 dbus cairo gtk2 gtk3 pango qt4 libuuid
  ];

  cmakeFlags = [
    "-DENABLE_QT_IM_MODULE=ON"
    "-DENABLE_GTK2_IM_MODULE=ON"
    "-DENABLE_GTK3_IM_MODULE=ON"
    "-DENABLE_GIR=OFF"
    "-DENABLE_OPENCC=OFF"
    "-DENABLE_PRESAGE=OFF"
    "-DENABLE_XDGAUTOSTART=OFF"
    "-DENABLE_PINYIN=${if withPinyin then "ON" else "OFF"}"
    "-DENABLE_TABLE=ON"
    "-DENABLE_SPELL=ON"
    "-DENABLE_QT_GUI=ON"
    "-DXKB_RULES_XML_FILE='${xkeyboard_config}/share/X11/xkb/rules/evdev.xml'"
  ];

  meta = with stdenv.lib; {
    homepage    = https://github.com/fcitx/fcitx;
    description = "A Flexible Input Method Framework";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
