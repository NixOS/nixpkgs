{ stdenv, fetchurl, cmake, openssl, sqlite, pkgconfig, systemd
, tlsSupport ? false }:

assert tlsSupport -> openssl != null;

stdenv.mkDerivation rec {
  name = "uhub-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "http://www.extatic.org/downloads/uhub/uhub-${version}-src.tar.bz2";
    sha256 = "1xcqjz20lxikzn96f4f69mqyl9y985h9g0gyc9f7ckj18q22b5j5";
  };

  buildInputs = [ cmake sqlite pkgconfig systemd ] ++ stdenv.lib.optional tlsSupport openssl;

  outputs = [ "out"
    "mod_example"
    "mod_welcome"
    "mod_logging"
    "mod_auth_simple"
    "mod_chat_history"
    "mod_chat_only"
    "mod_topic"
    "mod_no_guest_downloads"
  ];

  patches = [
    ./plugin-dir.patch

    # Fixed compilation on systemd > 210
    (fetchurl {
      url = "https://github.com/janvidar/uhub/commit/70f2a43f676cdda5961950a8d9a21e12d34993f8.diff";
      sha256 = "1jp8fvw6f9jh0sdjml9mahkk6p6b96p6rzg2y601mnnbcdj8y8xp";
    })
  ];

  cmakeFlags = ''
    -DSYSTEMD_SUPPORT=ON
    ${if tlsSupport then "-DSSL_SUPPORT=ON" else "-DSSL_SUPPORT=OFF"}
  '';

  meta = with stdenv.lib; {
    description = "High performance peer-to-peer hub for the ADC network";
    homepage = https://www.uhub.org/;
    license = licenses.gpl3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.unix;
  };
}
