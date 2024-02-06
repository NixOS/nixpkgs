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

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) nzbget; };

  meta = with lib; {
    homepage = "https://nzbget-ng.github.io/";
    changelog = "https://github.com/nzbget-ng/nzbget/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
})
