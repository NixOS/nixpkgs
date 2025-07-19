{
  lib,
  mkTclDerivation,
  fetchzip,
  libffi,
  libuuid,
}:

mkTclDerivation rec {
  pname = "cffi";
  version = "2.0.3";

  src = fetchzip {
    url = "mirror://sourceforge/magicsplat/cffi/cffi${version}-src.tar.gz";
    hash = "sha256-IcoDZu2P+yafntDNeDZS3NSwFuRgZgIBZCLhCdIY+6g=";
  };

  strictDeps = true;

  buildInputs = [
    libffi
    libuuid
  ];

  configureFlags = [
    "--disable-staticffi"
  ];

  meta = {
    description = "Foreign function interface (FFI) extension for Tcl";
    downloadPage = "https://sourceforge.net/projects/magicsplat/files/cffi";
    homepage = "https://cffi.magicsplat.com/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
