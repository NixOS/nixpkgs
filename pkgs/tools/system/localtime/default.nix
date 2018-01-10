{ stdenv, go, systemd, polkit, fetchFromGitHub, m4 }:

stdenv.mkDerivation {
  name = "localtime-2017-11-07";

  src = fetchFromGitHub {
    owner = "Stebalien";
    repo = "localtime";
    rev = "2e7b4317c723406bd75b2a1d640219ab9f8090ce";
    sha256 = "04fyna8p7q7skzx9fzmncd6gx7x5pwa9jh8a84hpljlvj0kldfs8";
  };
  
  buildInputs = [ go systemd polkit m4 ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "A daemon for keeping the system timezone up-to-date based on the current location";
    homepage = https://github.com/Stebalien/localtime;
    platforms = stdenv.lib.platforms.linux;
  };
}
