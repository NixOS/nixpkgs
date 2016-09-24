{ stdenv, fetchFromGitHub
, python3Packages
}:

stdenv.mkDerivation rec {
  name = "ibus-uniemoji-${version}";
  version = "2016-09-20";

  src = fetchFromGitHub {
    owner = "salty-horse";
    repo = "ibus-uniemoji";
    rev = "c8931a4807a721168e45463ecba00805adb3fe8d";
    sha256 = "0fydxkdjsbfbrbb8238rfnshmhp11c38hsa7y2gp1ii6mkjngb1j";
  };

  propagatedBuildInputs = with python3Packages; [ pyxdg python-Levenshtein ];

  makeFlags = [ "PREFIX=$(out)" "SYSCONFDIR=$(out)/etc"
                "PYTHON=${python3Packages.python.interpreter}" ];

  postPatch = ''
    sed -i "s,/etc/xdg/,$out/etc/xdg/," uniemoji.py
    sed -i "s,/usr/share/,$out/share/,g" uniemoji.xml.in
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "Input method (ibus) for entering unicode symbols and emoji by name";
    homepage     = "https://github.com/salty-horse/ibus-uniemoji";
    license      = with licenses; [ gpl3 mit ];
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ aske ];
  };
}
