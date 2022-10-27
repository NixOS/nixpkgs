{ stdenv, lib, fetchFromGitHub, autoreconfHook, pam, qrencode }:

stdenv.mkDerivation rec {
  pname = "google-authenticator-libpam";
  version = "1.09";

  src = fetchFromGitHub {
    owner = "google";
    repo = "google-authenticator-libpam";
    rev = version;
    hash = "sha256-DS0h6FWMNKnSSj039bH6iyWrERa5M7LBSkbyig6pyxY=";
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
    homepage = "https://github.com/google/google-authenticator-libpam";
    description = "Two-step verification, with pam module";
    license = licenses.asl20;
    maintainers = with maintainers; [ aneeshusa ];
    platforms = platforms.linux;
  };
}
