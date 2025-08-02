{
  fetchurl,
  lib,
}:
let
  version = "2023-10-31";
in
fetchurl {
  pname = "cellservdb";
  inherit version;
  url = "http://dl.central.org/dl/cellservdb/CellServDB.${version}";
  hash = "sha256-fuVHhTJI5FNwObBkAoTMZvZwVY4YEMTJX8fLpOVkQsU=";

  meta = {
    description = "GRAND.CENTRAL.ORG Public CellServDB";
    homepage = "https://grand.central.org/csdb.html";
    maintainers = [
      lib.maintainers.quentin
    ];
    # As a database, CellServDB is not copywritten.
    license = lib.licenses.publicDomain;
  };
}
