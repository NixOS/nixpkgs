{ lib, stdenv, fetchFromGitHub, buildEnv
, asio, boost, check, openssl, cmake
<<<<<<< HEAD
, nixosTests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "mariadb-galera";
<<<<<<< HEAD
  version = "26.4.15";
=======
  version = "26.4.14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "codership";
    repo = "galera";
    rev = "release_${version}";
<<<<<<< HEAD
    hash = "sha256-9CjxtNvsj2qM65u+R0pJZVwEaTdqtqURrfOGbT+/5ks=";
=======
    hash = "sha256-oRDzRylZEqmhtE70XWmwqt6eJaJyGgySjdxouznLP1g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ asio boost.dev check openssl ];

  preConfigure = ''
    # make sure bundled asio cannot be used, but leave behind license, because it gets installed
    rm -r asio/{asio,asio.hpp}
  '';

  postInstall = ''
    # for backwards compatibility
    mkdir $out/lib/galera
    ln -s $out/lib/libgalera_smm.so $out/lib/galera/libgalera_smm.so
  '';

<<<<<<< HEAD
  passthru.tests = {
    inherit (nixosTests) mariadb-galera;
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Galera 3 wsrep provider library";
    homepage = "https://galeracluster.com/";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ ajs124 izorkin ];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
}
