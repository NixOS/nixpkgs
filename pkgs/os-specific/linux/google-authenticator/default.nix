{ stdenv, lib, fetchurl, autoreconfHook, pam, qrencode }:

stdenv.mkDerivation rec {
  pname = "google-authenticator-libpam";
  version = "1.07";

  src = fetchurl {
    url = "https://github.com/google/google-authenticator-libpam/archive/${version}.tar.gz";
    sha256 = "01841dfmf6aw39idlv8y52b1nw9wx4skklzqhw1f519m0671ajhh";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ pam ];

  preConfigure = ''
    sed -i "s|libqrencode.so.4|${qrencode.out}/lib/libqrencode.so.4|" src/google-authenticator.c
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
