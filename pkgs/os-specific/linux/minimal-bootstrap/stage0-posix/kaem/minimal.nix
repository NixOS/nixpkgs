{ lib
, derivationWithMeta
, src
, hex0
, version
}:
derivationWithMeta {
  inherit version;
  pname = "kaem-minimal";
  builder = hex0;
  args = [
    "${src}/x86/kaem-minimal.hex0"
    (placeholder "out")
  ];

  meta = with lib; {
    description = "First stage minimal scriptable build tool for bootstrapping";
    homepage = "https://github.com/oriansj/stage0-posix";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = [ "i686-linux" ];
  };
}

