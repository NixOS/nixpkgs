{ stdenv, lib, fetchFromGitHub, openssl }:

let
  eMailSrc = fetchFromGitHub {
    owner = "deanproxy";
    repo = "eMail";
    rev = "7d23c8f508a52bd8809e2af4290417829b6bb5ae";
    sha256 = "1cxxzhm36civ6vjdgrk7mfmlzkih44kdii6l2xgy4r434s8rzcpn";
  };

  srcRoot = "eMail-${eMailSrc.rev}-src";

  dlibSrc = fetchFromGitHub {
    owner = "deanproxy";
    repo = "dlib";
    rev = "f62f29e918748b7cea476220f7492672be81c9de";
    sha256 = "0h34cikch98sb7nsqjnb9wl384c8ndln3m6yb1172l4y89qjg9rr";
  };

in

stdenv.mkDerivation {
  name = "email-git-2016-01-31";
  src = eMailSrc;

  buildInputs = [ openssl ];

  unpackPhase = ''
    unpackPhase;
    cp -Rp ${dlibSrc}/* ${srcRoot}/dlib;
    chmod -R +w ${srcRoot}/dlib;
  '';

  meta = {
    description = "Command line SMTP client";
    license = with lib.licenses; [ gpl2 ];
    homepage = http://deanproxy.com/code;
    platforms = stdenv.lib.platforms.unix;
  };
}
