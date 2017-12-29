{ coreutils, fetchFromGitHub, libcaca, makeWrapper, python, openssl, qrencode, stdenv, yubikey-manager }:

stdenv.mkDerivation {
  name = "gen-oath-safe-2017-01-23";
  src = fetchFromGitHub {
    owner = "mcepl";
    repo = "gen-oath-safe";
    rev = "fb53841";
    sha256 = "0018kqmhg0861r5xkbis2a1rx49gyn0dxcyj05wap5ms7zz69m0m";
  };

  buildInputs = [ makeWrapper ];

  buildPhase = ":";

  installPhase =
    let
      path = stdenv.lib.makeBinPath [
        coreutils
        libcaca.bin
        openssl.bin
        python
        qrencode
        yubikey-manager
      ];
    in
    ''
      mkdir -p $out/bin
      cp gen-oath-safe $out/bin/
      wrapProgram $out/bin/gen-oath-safe \
        --prefix PATH : ${path}
    '';
  meta = with stdenv.lib; {
    homepage = https://github.com/mcepl/gen-oath-safe;
    description = "Script for generating HOTP/TOTP keys (and QR code)";
    platforms =  platforms.unix;
    license = licenses.mit;
    maintainers = [ maintainers.makefu ];
  };

}
