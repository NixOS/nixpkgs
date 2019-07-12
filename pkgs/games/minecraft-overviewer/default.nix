{ buildPythonApplication, pillow, numpy, pkgconfig, fetchurl, lib }:

buildPythonApplication rec {
  pname = "minecraft-overviewer";
  version = "0.14.40";

  propagatedBuildInputs = [ pillow numpy ];

  nativeBuildInputs = [ pkgconfig ];

  src = fetchurl {
    url = "https://overviewer.org/builds/src/42/overviewer-${version}.tar.gz";
    sha256 = "0881sgr1c57jm9hhjzldbzksxmfvvzcl0isz80byyypg4x6rl22w";
  };

  patches = [ ./no-chmod.patch ];

  preBuild = ''
    unpackFile ${pillow.src}
    ln -s Pillow*/src/libImaging/Im*.h .
    python setup.py build
  '';

  meta = with lib; {
    description = "A command-line tool for rendering high-resolution maps of Minecraft worlds";
    homepage = "https://overviewer.org/";
    maintainers = with maintainers; [ lheckemann ];
    license = licenses.gpl3;
  };
}
