{ lib
, fetchurl
}:

{ domain ? "content.minetest.net"
, author
, technicalName
, release # Numeric release id (such as 1234)
, versionName ? toString release # Human-readable version (such as "1.2.3")
, sha256
}:

let
  inherit (lib.strings) sanitizeDerivationName;

in (fetchurl {
  name = "${sanitizeDerivationName author}-${sanitizeDerivationName technicalName}-${sanitizeDerivationName versionName}.zip";
  url = "https://${domain}/packages/${author}/${technicalName}/releases/${toString release}/download/";
  inherit sha256;
}) // {
  meta = {
    homepage = "https://${domain}/packages/${author}/${technicalName}";
    downloadPage = "https://${domain}/packages/${author}/${technicalName}/releases";
  };
}
