{ stdenv, lib, fetchurl, openssl, perl, pps-tools, libcap }:

stdenv.mkDerivation rec {
  pname = "ntp";
  version = "4.2.8p15";

  src = fetchurl {
    url = "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-${lib.versions.majorMinor version}/ntp-${version}.tar.gz";
    sha256 = "06cwhimm71safmwvp6nhxp6hvxsg62whnbgbgiflsqb8mgg40n7n";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-openssl-libdir=${openssl.out}/lib"
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
    homepage = "http://www.ntp.org/";
    description = "An implementation of the Network Time Protocol";
    license = {
      # very close to isc and bsd2
      url = "https://www.eecis.udel.edu/~mills/ntp/html/copyright.html";
    };
    maintainers = with maintainers; [ eelco thoughtpolice ];
    platforms = platforms.unix;
  };
}
