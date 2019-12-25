{ stdenv
, fetchFromGitHub
, gobject-introspection
, wrapGAppsHook
, python3
, ibus
}:

let
  python = python3.withPackages (ps: with ps; [
    pygobject3
    (toPythonModule ibus)
    pyxdg
    python-Levenshtein
  ]);
in stdenv.mkDerivation rec {
  pname = "ibus-uniemoji";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "salty-horse";
    repo = "ibus-uniemoji";
    rev = "v${version}";
    sha256 = "121zh3q0li1k537fcvbd4ns4jgl9bbb9gm9ihy8cfxgirv38lcfa";
  };

  patches = [
    # Do not run wrapper script with Python,
    # the wrapped script will have Python in shebang anyway.
    ./allow-wrapping.patch
  ];


  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    python
    ibus
  ];

  makeFlags = [
    "PREFIX=${placeholder ''out''}"
    "SYSCONFDIR=${placeholder ''out''}/etc"
    "PYTHON=${python.interpreter}"
  ];

  postFixup = ''
    wrapGApp $out/share/ibus-uniemoji/uniemoji.py
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description = "Input method (ibus) for entering unicode symbols and emoji by name";
    homepage = "https://github.com/salty-horse/ibus-uniemoji";
    license = with licenses; [ gpl3 mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ aske ];
  };
}
