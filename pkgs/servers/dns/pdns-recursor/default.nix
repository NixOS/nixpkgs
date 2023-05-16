{ lib, stdenv, fetchurl, pkg-config, boost, nixosTests
, openssl, systemd, lua, luajit, protobuf
, enableProtoBuf ? false
}:

stdenv.mkDerivation rec {
  pname = "pdns-recursor";
<<<<<<< HEAD
  version = "4.9.1";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-recursor-${version}.tar.bz2";
    sha256 = "sha256-Ch7cE+jyvWYfOeMWOH2UHiLeagO4p6L8Zi/fi5Quor4=";
=======
  version = "4.8.4";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-recursor-${version}.tar.bz2";
    sha256 = "sha256-8KY/0I4D2oL6INMz6lF50bkln0JkVGz0mVKGZ32UWMc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost openssl systemd
    lua luajit
  ] ++ lib.optional enableProtoBuf protobuf;

  configureFlags = [
    "--enable-reproducible"
    "--enable-systemd"
<<<<<<< HEAD
    "sysconfdir=/etc/pdns-recursor"
  ];

  installFlags = [ "sysconfdir=$(out)/etc/pdns-recursor" ];

=======
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) pdns-recursor ncdns;
  };

  meta = with lib; {
    description = "A recursive DNS server";
    homepage = "https://www.powerdns.com/";
    platforms = platforms.linux;
    badPlatforms = [
      "i686-linux"  # a 64-bit time_t is needed
    ];
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
