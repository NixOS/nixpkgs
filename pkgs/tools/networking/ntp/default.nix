{ stdenv, lib, fetchurl, openssl, perl, pps-tools, libcap }:

stdenv.mkDerivation rec {
  pname = "ntp";
  version = "4.2.8p17";

  src = fetchurl {
    url = "https://archive.ntp.org/ntp4/ntp-${lib.versions.majorMinor version}/ntp-${version}.tar.gz";
    hash = "sha256-ED3ScuambFuN8H3OXpoCVV/NbxOXvft4IjcyjonTqGY=";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-openssl-libdir=${lib.getLib openssl}/lib"
    "--with-openssl-incdir=${openssl.dev}/include"
    "--enable-ignore-dns-errors"
    "--with-yielding-select=yes"
  ] ++ lib.optional stdenv.isLinux "--enable-linuxcaps";

  buildInputs = [ openssl perl ]
    ++ lib.optionals stdenv.isLinux [ pps-tools libcap ];

  hardeningEnable = [ "pie" ];

  postInstall = ''
    rm -rf $out/share/doc
  '';

  meta = with lib; {
    homepage = "https://www.ntp.org/";
    description = "Implementation of the Network Time Protocol";
    license = {
      # very close to isc and bsd2
      url = "https://www.eecis.udel.edu/~mills/ntp/html/copyright.html";
    };
    maintainers = with maintainers; [ eelco thoughtpolice ];
    platforms = platforms.unix;
  };
}
