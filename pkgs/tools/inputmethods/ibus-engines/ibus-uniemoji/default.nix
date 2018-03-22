{ stdenv, fetchFromGitHub
, python3Packages
}:

stdenv.mkDerivation rec {
  name = "ibus-uniemoji-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "salty-horse";
    repo = "ibus-uniemoji";
    rev = "v${version}";
    sha256 = "121zh3q0li1k537fcvbd4ns4jgl9bbb9gm9ihy8cfxgirv38lcfa";
  };

  propagatedBuildInputs = with python3Packages; [ pyxdg python-Levenshtein pygobject3 ];

  nativeBuildInputs = [ python3Packages.wrapPython ];

  postFixup = ''
    buildPythonPath $out
    patchPythonScript $out/share/ibus-uniemoji/uniemoji.py
  '';

  makeFlags = [ "PREFIX=$(out)" "SYSCONFDIR=$(out)/etc"
                "PYTHON=${python3Packages.python.interpreter}"
              ];

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "Input method (ibus) for entering unicode symbols and emoji by name";
    homepage     = "https://github.com/salty-horse/ibus-uniemoji";
    license      = with licenses; [ gpl3 mit ];
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ aske ];
  };
}
