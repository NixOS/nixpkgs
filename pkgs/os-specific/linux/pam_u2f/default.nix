{ stdenv, fetchurl, pkgconfig, libu2f-host, libu2f-server, pam }:

stdenv.mkDerivation rec {
  name    = "pam_u2f-${version}";
  version = "1.0.1";

  src     = fetchurl {
    url = "https://developers.yubico.com/pam-u2f/Releases/${name}.tar.gz";
    sha256 = "08lmc2il877k7djkjmza3k0n6ij8b4hx4x9dl6wwfdjqsr8d2zfp";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libu2f-host libu2f-server pam ];

  # Fix the broken include in 1.0.1
  CFLAGS = "-I${libu2f-host}/include/u2f-host";

  preConfigure = ''
    configureFlagsArray+=("--with-pam-dir=$out/lib/security")
  '';

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/pam-u2f/;
    description = "A PAM module for allowing authentication with a U2F device";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ philandstuff ];
  };
}
