{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "synapse-admin";
  version = "0.8.3";

  src = fetchzip {
    url = "https://github.com/Awesome-Technologies/synapse-admin/releases/download/${version}/synapse-admin-${version}.tar.gz";
    hash = "sha256-LAdMxzUffnykiDHvQYu9uNxK4428Q9CxQY2q02AcUco=";
  };

  installPhase = ''
    cp -r . $out
  '';

  meta = with lib; {
    description = "Admin UI for Synapse Homeservers";
    homepage = "https://github.com/Awesome-Technologies/synapse-admin";
    license = licenses.apsl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
