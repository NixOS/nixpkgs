{ buildPythonApplication, pillow, numpy, pkgconfig, fetchurl, lib }:

buildPythonApplication rec {
  pname = "minecraft-overviewer";
  version = "0.13.90";

  propagatedBuildInputs = [ pillow numpy ];

  nativeBuildInputs = [ pkgconfig ];

  src = fetchurl {
    url = "https://overviewer.org/builds/src/131/overviewer-0.13.90.tar.gz";
    sha256 = "0qlpliby2gypdhn4bfxwdphhjbvabvjy8smhpw24i4zcnqll97ya";
  };

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
