{ stdenv
, fetchurl
, python }:

python.pkgs.buildPythonApplication rec {
  pname = "20kly";
  version = "1.4";
  format = "other";
  disabled = !(python.isPy2 or false);

  src = fetchurl {
    url = "http://jwhitham.org.uk/20kly/lightyears-${version}.tar.bz2";
    sha256 = "13h73cmfjqkipffimfc4iv0hf89if490ng6vd6xf3wcalpgaim5d";
  };

  patchPhase = ''
    substituteInPlace lightyears \
      --replace \
        "LIGHTYEARS_DIR = \".\"" \
        "LIGHTYEARS_DIR = \"$out/share\""
  '';

  propagatedBuildInputs = with python.pkgs; [ pygame ];

  buildPhase = "python -O -m compileall .";

  installPhase = ''
    mkdir -p "$out/share"
    cp -r audio code data lightyears "$out/share"
    install -Dm755 lightyears "$out/bin/lightyears"
  '';

  meta = with stdenv.lib; {
    description = "A steampunk-themed strategy game where you have to manage a steam supply network";
    homepage = http://jwhitham.org.uk/20kly/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
  };
}

