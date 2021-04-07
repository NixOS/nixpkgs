{ lib, stdenv, fetchurl, pkg-config, boost, nixosTests
, openssl, systemd, lua, luajit, protobuf
, enableProtoBuf ? false
}:

stdenv.mkDerivation rec {
  pname = "pdns-recursor";
  version = "4.4.2";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-recursor-${version}.tar.bz2";
    sha256 = "1kzmliim2pwh04y3y6bpai9fm0qmdicrmff09fv5h5wahi4pzfdh";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost openssl systemd
    lua luajit
  ] ++ lib.optional enableProtoBuf protobuf;

  configureFlags = [
    "--enable-reproducible"
    "--enable-systemd"
  ];

  enableParallelBuilding = true;

  passthru.tests = {
    nixos = nixosTests.pdns-recursor;
  };

  meta = with lib; {
    description = "A recursive DNS server";
    homepage = "https://www.powerdns.com/";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
