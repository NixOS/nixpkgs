{ lib
, stdenv
, fetchurl
, bc
, check
, curl
}:

stdenv.mkDerivation rec {
  pname = "recutils";
  version = "1.8";

  src = fetchurl {
    url = "mirror://gnu/recutils/${pname}-${version}.tar.gz";
    hash = "sha256-346uaVk/26U+Jky/SyMH37ghIMCbb6sj4trVGomlsZM=";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [
    curl
  ];

  checkInputs = [
    check
    bc
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
