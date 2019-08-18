{ stdenv, lib, fetchFromGitHub, pkgconfig, glib, procps, libxml2 }:

stdenv.mkDerivation rec {
  pname = "dbus-map";
  version = "2015-05-28";
  src = fetchFromGitHub {
    owner = "taviso";
    repo = "dbusmap";
    rev = "43703fc5e15743309b67131b5ba457b0d6ea7667";
    sha256 = "1pjqn6w29ci8hfxkn1aynzfc8nvy3pqv3hixbxwr7qx20g4rwvdc";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    glib procps libxml2
  ];
  installPhase = ''
    mkdir -p $out/bin
    mv dbus-map $out/bin
  '';
  meta = with lib; {
    description = "Simple utility for enumerating D-Bus endpoints, an nmap for D-Bus";
    homepage = https://github.com/taviso/dbusmap;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
