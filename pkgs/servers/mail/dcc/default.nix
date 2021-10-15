{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dcc";
  version = "2.3.168";

  src = fetchurl {
    url = "https://www.dcc-servers.net/dcc/source/old/${pname}-${version}.tar.Z";
    sha256 = "sha256-P8kyMls2pGqTJYvapIPQDuOoJr6h0A3gT26Ez76mO8I=";
  };

  dontAddPrefix = true;
  setOutputFlags = false;

  configureFlags = [
    "--disable-sys-inst"
    "--with-installroot=${placeholder "out"}"
    "--bindir=/bin"
    "--mandir=/share/man"
    "--homedir=/share/${pname}"
    "--libexecdir=/libexec"
  ];

  outputs = [ "out" "data" ];

  postInstall = ''
    mv $out/share/* $data/
    rmdir $out/share
  '';

  installFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Distributed Checksum Clearinghouses";
    homepage = "https://www.dcc-servers.net/dcc/";
    license = licenses.free;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
