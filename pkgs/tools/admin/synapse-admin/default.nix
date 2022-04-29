{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "synapse-admin";
  version = "0.8.5";

  src = fetchzip {
    url = "https://github.com/Awesome-Technologies/synapse-admin/releases/download/${version}/synapse-admin-${version}.tar.gz";
    hash = "sha256-5wMKRaLMVJer6W2q2WuofgzVwr8Myi90DQ8tBVAoUX4=";
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
