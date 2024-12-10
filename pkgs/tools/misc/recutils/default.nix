{
  lib,
  stdenv,
  fetchurl,
  bc,
  check,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "recutils";
  version = "1.9";

  src = fetchurl {
    url = "mirror://gnu/recutils/${pname}-${version}.tar.gz";
    hash = "sha256-YwFZKwAgwUtFZ1fvXUNNSfYCe45fOkmdEzYvIFxIbg4=";
  };

  hardeningDisable = lib.optional stdenv.cc.isClang "format";

  buildInputs = [
    curl
  ];

  nativeCheckInputs = [
    bc
    check
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/recutils/";
    description = "Tools and libraries to access human-editable, text-based databases";
    longDescription = ''
      GNU Recutils is a set of tools and libraries to access human-editable,
      text-based databases called recfiles. The data is stored as a sequence of
      records, each record containing an arbitrary number of named fields.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
}
