{ stdenv, fetchurl, cmake, openssl, sqlite, pkgconfig, systemd
, tlsSupport ? false }:

assert tlsSupport -> openssl != null;

let version = "0.4.1"; in
stdenv.mkDerivation {
  name = "uhub-${version}";

  src = fetchurl {
    url = "http://www.extatic.org/downloads/uhub/uhub-${version}-src.tar.bz2";
    sha256 = "1q0n74fb0h5w0k9fhfkznxb4r46qyfb8g2ss3wflivx4l0m1f9x2";
  };

  buildInputs = [ cmake sqlite pkgconfig systemd ] ++ stdenv.lib.optional tlsSupport openssl;

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

  patches = [ ./plugin-dir.patch ./systemd.patch ];

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