{ lib, stdenv, fetchFromGitHub, buildEnv
, asio, boost, check, openssl, cmake
}:

stdenv.mkDerivation rec {
  pname = "mariadb-galera";
  version = "26.4.9";

  src = fetchFromGitHub {
    owner = "codership";
    repo = "galera";
    rev = "release_${version}";
    sha256 = "1nf8vv0b9v7rjsxl93avgvv0lz5jjg91brnric0dhlnp2dzzxi6g";
    fetchSubmodules = true;
  };

  buildInputs = [ asio boost check openssl cmake ];

  preConfigure = ''
    # make sure bundled asio cannot be used, but leave behind license, because it gets installed
    rm -r asio/{asio,asio.hpp}
  '';

  postInstall = ''
    # for backwards compatibility
    mkdir $out/lib/galera
    ln -s $out/lib/libgalera_smm.so $out/lib/galera/libgalera_smm.so
  '';

  meta = with lib; {
    description = "Galera 3 wsrep provider library";
    homepage = "https://galeracluster.com/";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ ajs124 izorkin ];
    platforms = platforms.all;
  };
}
