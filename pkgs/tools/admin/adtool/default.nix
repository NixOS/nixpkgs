{ lib, stdenv, fetchurl, openldap }:

stdenv.mkDerivation rec {
  pname = "adtool";
  version = "1.3.3";

  src = fetchurl {
    url = "https://gp2x.org/adtool/${pname}-${version}.tar.gz";
    sha256  = "1awmpjamrwivi69i0j2fyrziy9s096ckviqd9c4llc3990mfsn4n";
  };

  configureFlags = [
    "--sysconfdir=/etc"
  ];

  installFlags = [
    "sysconfdir=$(out)/etc"
  ];

  buildInputs = [ openldap ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/share/doc/adtool
    mv $out/etc/* $out/share/doc/adtool
    rmdir $out/etc
  '';

  # It requires an LDAP server for tests
  doCheck = false;

  meta = with lib; {
    description = "Active Directory administration utility for Unix";
    homepage = "https://gp2x.org/adtool";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
