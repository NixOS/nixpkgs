{ coreutils, fetchFromGitHub, libcaca, makeWrapper, python, openssl, qrencode, stdenv, yubikey-manager }:

stdenv.mkDerivation rec {
  pname = "gen-oath-safe";
  version = "0.11.0";
  src = fetchFromGitHub {
    owner = "mcepl";
    repo = "gen-oath-safe";
    rev = version;
    sha256 = "1914z0jgj7lni0nf3hslkjgkv87mhxdr92cmhmbzhpjgjgr23ydp";
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
