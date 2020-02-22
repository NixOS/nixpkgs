{ stdenv, fetchpatch, fetchFromGitHub, cmake, openssl, sqlite, pkgconfig, systemd
, tlsSupport ? false }:

assert tlsSupport -> openssl != null;

stdenv.mkDerivation rec {
  pname = "uhub";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "janvidar";
    repo = "uhub";
    rev = version;
    sha256 = "0zdbxfvw7apmfhqgsfkfp4pn9iflzwdn0zwvzymm5inswfc00pxg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake sqlite systemd ] ++ stdenv.lib.optional tlsSupport openssl;

  outputs = [ "out"
    "mod_example"
    "mod_welcome"
    "mod_logging"
    "mod_auth_simple"
    "mod_auth_sqlite"
    "mod_chat_history"
    "mod_chat_only"
    "mod_topic"
    "mod_no_guest_downloads"
  ];

  patches = [
    ./plugin-dir.patch
    # fix aarch64 build: https://github.com/janvidar/uhub/issues/46
    (fetchpatch {
      url = "https://github.com/janvidar/uhub/pull/47.patch";
      sha256 = "07yik6za89ar5bxm7m2183i7f6hfbawbxvd4vs02n1zr2fgfxmiq";
    })

    # Fixed compilation on systemd > 210
    (fetchpatch {
      url = "https://github.com/janvidar/uhub/commit/70f2a43f676cdda5961950a8d9a21e12d34993f8.diff";
      sha256 = "1jp8fvw6f9jh0sdjml9mahkk6p6b96p6rzg2y601mnnbcdj8y8xp";
    })
  ];

  cmakeFlags = [
    "-DSYSTEMD_SUPPORT=ON"
    (if tlsSupport then "-DSSL_SUPPORT=ON" else "-DSSL_SUPPORT=OFF")
  ];

  meta = with stdenv.lib; {
    description = "High performance peer-to-peer hub for the ADC network";
    homepage = https://www.uhub.org/;
    license = licenses.gpl3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.unix;
  };
}
