{ lib, stdenv, fetchurl, pkg-config, libnetfilter_acct, libmnl }:

stdenv.mkDerivation rec {
  pname = "nfacct";
  version = "1.0.2";

  src = fetchurl {
    url = "https://netfilter.org/projects/${pname}/files/${pname}-${version}.tar.bz2";
    sha256 = "sha256-7P8iGHVL4xi848Ol0Xdbq5O/QWiyxKrEZXhd5WVfvWk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libnetfilter_acct libmnl ];

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/${pname} help > /dev/null
  '';

  meta = with lib; {
    description = "A command line tool to create/retrieve/delete accounting objects";
    homepage = "https://www.netfilter.org/projects/nfacct/index.html";
    platforms = platforms.linux;
    maintainers = with maintainers; [ thomassdk ];
    license = licenses.gpl2;
    downloadPage = "https://www.netfilter.org/projects/nfacct/files/";
  };
}
