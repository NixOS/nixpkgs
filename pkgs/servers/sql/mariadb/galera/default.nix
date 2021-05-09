{ lib, stdenv, fetchFromGitHub, buildEnv
, asio, boost, check, openssl, cmake
}:

stdenv.mkDerivation rec {
  pname = "mariadb-galera";
  version = "26.4.8";

  src = fetchFromGitHub {
    owner = "codership";
    repo = "galera";
    rev = "release_${version}";
    sha256 = "0rx710dfijiykpi41rhxx8vafk07bffv2nbl3d4ggc32rzv88369";
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
