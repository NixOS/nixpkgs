{ stdenv, lib, fetchFromGitHub, openssl }:

let
  eMailSrc = fetchFromGitHub {
    #awaiting acceptance of https://github.com/deanproxy/eMail/pull/29
    owner = "jerith666";
    repo = "eMail";
    rev = "d9fd259f952b573d320916ee34e807dd3dd24b1f";
    sha256 = "0q4ly4bhlv6lrlj5kmjs491aah1afmkjyw63i9yqnz4d2k6npvl9";
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
  };
}