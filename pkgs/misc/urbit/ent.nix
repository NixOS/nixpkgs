{ urbit-src, lib, stdenv }:

stdenv.mkDerivation {
  pname = "ent";
  version = urbit-src.rev;
  src = lib.cleanSource "${urbit-src}/pkg/ent";

  postPatch = ''
    patchShebangs ./configure
  '';

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = {
    description = "Cross-platform wrapper around getentropy";
    homepage = "https://github.com/urbit/urbit";
    license = lib.licenses.free;
    maintainers = [ lib.maintainers.uningan ];
    platforms = lib.platforms.unix;
  };
}
