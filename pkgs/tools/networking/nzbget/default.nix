<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, gnutls
, libgcrypt
, libpar2
, libcap
, libsigcxx
, libxml2
, ncurses
, openssl
, zlib
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nzbget-ng";
  version = "21.4-rc2";

  src = fetchFromGitHub {
    owner = "nzbget-ng";
    repo = "nzbget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JJML5mtAog5xC7DkthCtoyn5QeC2Z+fdzSuEa/Te0Ew=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    gnutls
    libgcrypt
    libpar2
    libcap
    libsigcxx
    libxml2
    ncurses
    openssl
    zlib
  ];

  prePatch = ''
    sed -i 's/AC_INIT.*/AC_INIT( nzbget, m4_esyscmd_s( echo ${finalAttrs.version} ) )/' configure.ac
  '';
=======
{ lib, stdenv, fetchurl, pkg-config, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt, zlib, openssl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "nzbget";
  version = "21.1";

  src = fetchurl {
    url = "https://github.com/nzbget/nzbget/releases/download/v${version}/nzbget-${version}-src.tar.gz";
    sha256 = "sha256-To/BvrgNwq8tajajOjP0Te3d1EhgAsZE9MR5MEMHICU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libxml2 ncurses libsigcxx libpar2 gnutls
                  libgcrypt zlib openssl ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) nzbget; };

  meta = with lib; {
<<<<<<< HEAD
    homepage = "https://nzbget-ng.github.io/";
    changelog = "https://github.com/nzbget-ng/nzbget/releases/tag/v${finalAttrs.version}";
=======
    homepage = "https://nzbget.net";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
