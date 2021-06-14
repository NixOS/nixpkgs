{ lib, stdenv, fetchFromGitHub, autoreconfHook
, libpcap, texinfo
, iptables
, gnupgSupport ? true, gnupg, gpgme # Increases dependencies!
, wgetSupport ? true, wget
, buildServer ? true
, buildClient ? true }:

stdenv.mkDerivation rec {
  pname = "fwknop";
  version = "2.6.10";

  src = fetchFromGitHub {
    owner = "mrash";
    repo = pname;
    rev = version;
    sha256 = "05kvqhmxj9p2y835w75f3jvhr38bb96cd58mvfd7xil9dhmhn9ra";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libpcap texinfo ]
    ++ lib.optionals gnupgSupport [ gnupg gpgme.dev ]
    ++ lib.optionals wgetSupport [ wget ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/run"
    "--with-iptables=${iptables}/sbin/iptables"
    (lib.enableFeature buildServer "server")
    (lib.enableFeature buildClient "client")
    (lib.withFeatureAs wgetSupport "wget" "${wget}/bin/wget")
  ] ++ lib.optionalString gnupgSupport [
    "--with-gpgme"
    "--with-gpgme-prefix=${gpgme.dev}"
    "--with-gpg=${gnupg}"
  ];

  # Temporary hack to copy the example configuration files into the nix-store,
  # this'll probably be helpful until there's a NixOS module for that (feel free
  # to ping me (@primeos) if you want to help).
  preInstall = ''
    substituteInPlace Makefile --replace\
      "sysconfdir = /etc"\
      "sysconfdir = $out/etc"
    substituteInPlace server/Makefile --replace\
      "wknopddir = /etc/fwknop"\
      "wknopddir = $out/etc/fwknop"
  '';

  meta = with lib; {
    description =
      "Single Packet Authorization (and Port Knocking) server/client";
    longDescription = ''
      fwknop stands for the "FireWall KNock OPerator", and implements an
      authorization scheme called Single Packet Authorization (SPA).
    '';
    homepage = "https://www.cipherdyne.org/fwknop/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
