<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
=======
{ lib, stdenv, fetchFromGitHub
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, postgresql
, openssl
, zlib
, readline
, flex
<<<<<<< HEAD
, curl
, json_c
, libxcrypt
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "repmgr";
<<<<<<< HEAD
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "repmgr";
    rev = "v${version}";
    sha256 = "sha256-OaEoP1BajVW9dt8On9Ppf8IXmAk47HHv8zKw3WlsLHw=";
=======
  version = "5.3.2";

  src = fetchFromGitHub {
    owner = "2ndQuadrant";
    repo = "repmgr";
    rev = "v${version}";
    sha256 = "sha256-M8FMin9y6nAiPYeT5pUUy0KyZ1dkuH708GshZ6GoXXw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ flex ];

<<<<<<< HEAD
  buildInputs = [ postgresql openssl zlib readline curl json_c ]
    ++ lib.optionals (stdenv.isLinux && lib.versionOlder postgresql.version "13") [ libxcrypt ];
=======
  buildInputs = [ postgresql openssl zlib readline ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase = ''
    mkdir -p $out/{bin,lib,share/postgresql/extension}

    cp repmgr{,d} $out/bin
    cp *.so       $out/lib
    cp *.sql      $out/share/postgresql/extension
    cp *.control  $out/share/postgresql/extension
  '';

  meta = with lib; {
    homepage = "https://repmgr.org/";
    description = "Replication manager for PostgreSQL cluster";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ zimbatm ];
  };
}
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
