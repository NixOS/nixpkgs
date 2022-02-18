{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "synapse-admin";
  version = "0.8.4";

  src = fetchzip {
    url = "https://github.com/Awesome-Technologies/synapse-admin/releases/download/${version}/synapse-admin-${version}.tar.gz";
    hash = "sha256-hRjguUQUK7tB4VWVKRid4sRTIF/ulm9RmNA6RNUfaak=";
  };

  installPhase = ''
    cp -r . $out
  '';

  meta = with lib; {
    description = "Admin UI for Synapse Homeservers";
    homepage = "https://github.com/Awesome-Technologies/synapse-admin";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
