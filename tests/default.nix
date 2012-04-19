{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };

{
  avahi = makeTest (import ./avahi.nix);
  bittorrent = makeTest (import ./bittorrent.nix);
  firefox = makeTest (import ./firefox.nix);
  firewall = makeTest (import ./firewall.nix);
  installer = makeTests (import ./installer.nix);
  ipv6 = makeTest (import ./ipv6.nix);
  kde4 = makeTest (import ./kde4.nix);
  login = makeTest (import ./login.nix);
  misc = makeTest (import ./misc.nix);
  mpich = makeTest (import ./mpich.nix);
  mysql = makeTest (import ./mysql.nix);
  mysql_replication = makeTest (import ./mysql-replication.nix);
  nat = makeTest (import ./nat.nix);
  nfs = makeTest (import ./nfs.nix);
  openssh = makeTest (import ./openssh.nix);
  portmap = makeTest (import ./portmap.nix);
  proxy = makeTest (import ./proxy.nix);
  quake3 = makeTest (import ./quake3.nix);
  simple = makeTest (import ./simple.nix);
  #subversion = makeTest (import ./subversion.nix);
  tomcat = makeTest (import ./tomcat.nix);
  trac = makeTest (import ./trac.nix);
  xfce = makeTest (import ./xfce.nix);
}
