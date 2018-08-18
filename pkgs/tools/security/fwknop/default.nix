{ stdenv, fetchFromGitHub, autoreconfHook, lib
, libpcap, texinfo
, iptables
, gnupgSupport ? true, gnupg, gpgme # Increases dependencies!
, wgetSupport ? true, wget
, buildServer ? true
, buildClient ? true }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
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
    ++ stdenv.lib.optional gnupgSupport [ gnupg gpgme.dev ]
    ++ stdenv.lib.optional wgetSupport [ wget ];

  configureFlags = ''
    --sysconfdir=/etc
    --localstatedir=/run
    --with-iptables=${iptables}/sbin/iptables
    ${lib.optionalString (!buildServer) "--disable-server"}
    ${lib.optionalString (!buildClient) "--disable-client"}
    ${lib.optionalString gnupgSupport ''
      --with-gpgme
      --with-gpgme-prefix=${gpgme.dev}
      --with-gpg=${gnupg}
    ''}
    ${lib.optionalString wgetSupport ''
      --with-wget=${wget}/bin/wget
    ''}
  '';

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

  meta = with stdenv.lib; {
    description =
      "Single Packet Authorization (and Port Knocking) server/client";
    longDescription = ''
      fwknop stands for the "FireWall KNock OPerator", and implements an
      authorization scheme called Single Packet Authorization (SPA).
    '';
    homepage = https://www.cipherdyne.org/fwknop/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
