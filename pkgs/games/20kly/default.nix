{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "20kly";
  version = "1.5.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "20kly";
    repo = "20kly";
    rev = "v${version}";
    sha256 = "1zxsxg49a02k7zidx3kgk2maa0vv0n1f9wrl5vch07sq3ghvpphx";
  };

  patchPhase = ''
    substituteInPlace lightyears \
      --replace \
        "LIGHTYEARS_DIR = \".\"" \
        "LIGHTYEARS_DIR = \"$out/share\""
  '';

  propagatedBuildInputs = with python3Packages; [
    pygame
  ];

  buildPhase = ''
    python -O -m compileall .
  '';

  installPhase = ''
    mkdir -p "$out/share"
    cp -r data lib20k lightyears "$out/share"
    install -Dm755 lightyears "$out/bin/lightyears"
  '';

  meta = with lib; {
    description = "Steampunk-themed strategy game where you have to manage a steam supply network";
    mainProgram = "lightyears";
    homepage = "http://jwhitham.org.uk/20kly/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fgaz ];
  };
}
