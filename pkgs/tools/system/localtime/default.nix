{ stdenv, systemd, polkit, fetchFromGitHub, buildGoPackage, m4}:

buildGoPackage rec {
  name = "localtime-2017-11-07";

  src = fetchFromGitHub {
    owner = "Stebalien";
    repo = "localtime";
    rev = "2e7b4317c723406bd75b2a1d640219ab9f8090ce";
    sha256 = "04fyna8p7q7skzx9fzmncd6gx7x5pwa9jh8a84hpljlvj0kldfs8";
  };
  goPackagePath = "github.com/Stebalien/localtime";

  buildInputs = [ systemd polkit m4 ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildPhase = ''
    cd go/src/${goPackagePath}
    make localtimed
  '';

  installPhase = ''
    mkdir -p $bin/bin
    install -Dm555 localtimed $bin/bin
  '';

  meta = with stdenv.lib; {
    description = "A daemon for keeping the system timezone up-to-date based on the current location";
    homepage = https://github.com/Stebalien/localtime;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
