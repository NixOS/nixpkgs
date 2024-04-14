{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, boost
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
  pname = "nzbget";
  version = "23.0";

  src = fetchFromGitHub {
    owner = "nzbgetcom";
    repo = "nzbget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JqC82zpsIqRYB7128gTSOQMWJFR/t63NJXlPgGqP0jE=";
  };

  patches = [
    # add nzbget-ng patch not in nzbgetcom for buffer overflow issue -- see https://github.com/nzbget-ng/nzbget/pull/43
    (fetchpatch {
      url = "https://github.com/nzbget-ng/nzbget/commit/8fbbbfb40003c6f32379a562ce1d12515e61e93e.patch";
      hash = "sha256-mgI/twEoMTFMFGfH1/Jm6mE9u9/CE6RwELCSGx5erUo=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    boost
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
    homepage = "https://nzbget.com/";
    changelog = "https://github.com/nzbgetcom/nzbget/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub devusb ];
    platforms = with platforms; unix;
    mainProgram = "nzbget";
  };
})
