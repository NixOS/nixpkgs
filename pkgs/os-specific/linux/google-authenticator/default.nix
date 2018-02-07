{ stdenv, lib, fetchurl, autoreconfHook, pam, qrencode }:

stdenv.mkDerivation rec {
  name = "google-authenticator-libpam-${version}";
  version = "1.03";

  src = fetchurl {
    url = "https://github.com/google/google-authenticator-libpam/archive/${version}.tar.gz";
    sha256 = "0wb95z5v1w4sk0p7y9pbn4v95w9hrbf80vw9k2z2sgs0156ljkb7";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ pam ];

  preConfigure = ''
    sed -i "s|libqrencode.so.3|${qrencode}/lib/libqrencode.so.3|" src/google-authenticator.c
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/security
    cp ./.libs/pam_google_authenticator.so $out/lib/security
    cp google-authenticator $out/bin
  '';

  meta = with lib; {
    homepage = https://github.com/google/google-authenticator-libpam;
    description = "Two-step verification, with pam module";
    license = licenses.asl20;
    maintainers = with maintainers; [ aneeshusa ];
    platforms = platforms.linux;
  };
}
