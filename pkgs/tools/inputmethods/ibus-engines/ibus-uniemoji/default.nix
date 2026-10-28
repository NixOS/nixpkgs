{
  lib,
  stdenv,
  fetchFromGitHub,
  gobject-introspection,
  wrapGAppsHook3,
  python3,
  ibus,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      pygobject3
      (toPythonModule ibus)
      pyxdg
      levenshtein
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "ibus-uniemoji";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "salty-horse";
    repo = "ibus-uniemoji";
    tag = "v${version}";
    hash = "sha256-iP72lExXnLFeWNJQfaDI/T4tRlXjHbRy+1X8+cAT+Zo=";
  };

  patches = [
    # Do not run wrapper script with Python,
    # the wrapped script will have Python in shebang anyway.
    ./allow-wrapping.patch
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    python
    ibus
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
    "PYTHON=${python.interpreter}"
  ];

  postFixup = ''
    chmod +x      "$out/share/ibus-uniemoji/ibus.py"
    patchShebangs "$out/share/ibus-uniemoji/ibus.py"
    wrapGApp      "$out/share/ibus-uniemoji/ibus.py"
  '';

  meta = {
    isIbusEngine = true;
    description = "Input method (ibus) for entering unicode symbols and emoji by name";
    homepage = "https://github.com/salty-horse/ibus-uniemoji";
    license = with lib.licenses; [
      gpl3
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aske ];
  };
}
