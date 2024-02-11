{ lib
, mkDerivation
, fetchurl
, fetchFromGitHub
, cmake
, extra-cmake-modules
, boost
, libime
, fcitx5
, fcitx5-qt
, fcitx5-lua
, qtwebengine
, opencc
, curl
, fmt
, luaSupport ? true
}:

let
  pyStrokeVer = "20121124";
  pyStroke = fetchurl {
    url = "http://download.fcitx-im.org/data/py_stroke-${pyStrokeVer}.tar.gz";
    sha256 = "0j72ckmza5d671n2zg0psg7z9iils4gyxz7jgkk54fd4pyljiccf";
  };
  pyTableVer = "20121124";
  pyTable = fetchurl {
    url = "http://download.fcitx-im.org/data/py_table-${pyTableVer}.tar.gz";
    sha256 = "011cg7wssssm6hm564cwkrrnck2zj5rxi7p9z5akvhg6gp4nl522";
  };
in

mkDerivation rec {
  pname = "fcitx5-chinese-addons";
  version = "5.1.3";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-z+udRjvAZbnu6EcvvdaFVCr0OKLxFBJbgoYpH9QjrDI=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    boost
    fcitx5-lua
  ];

  prePatch = ''
    ln -s ${pyStroke} modules/pinyinhelper/$(stripHash ${pyStroke})
    ln -s ${pyTable} modules/pinyinhelper/$(stripHash ${pyTable})
  '';

  buildInputs = [
    fcitx5
    fcitx5-qt
    libime
    curl
    opencc
    qtwebengine
    fmt
  ] ++ lib.optional luaSupport fcitx5-lua;

  meta = with lib; {
    description = "Addons related to Chinese, including IME previous bundled inside fcitx4";
    homepage = "https://github.com/fcitx/fcitx5-chinese-addons";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
