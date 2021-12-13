{ lib
, fetchurl
, nettools
, openssl
, readline
, stdenv
, which
}:

stdenv.mkDerivation rec {
  pname = "socat";
  version = "1.7.4.2";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ZpCp+ZkEV7UFCXonK78sv0zDVXYXb3ZkbjUksOkcF2M=";
  };

  patches = [
    # This adds missing feature checks for TCP_INFO, a Linux feature
    #
    # Discussed in https://github.com/Homebrew/homebrew-core/pull/88595
    ./socat-fix-feature-check-tcpinfo.patch
  ];

  postPatch = ''
    patchShebangs test.sh
    substituteInPlace test.sh \
      --replace /bin/rm rm \
      --replace /sbin/ifconfig ifconfig
  '';

  buildInputs = [ openssl readline ];

  hardeningEnable = [ "pie" ];

  checkInputs = [ which nettools ];
  doCheck = false; # fails a bunch, hangs

  meta = with lib; {
    description = "Utility for bidirectional data transfer between two independent data channels";
    homepage = "http://www.dest-unreach.org/socat/";
    repositories.git = "git://repo.or.cz/socat.git";
    platforms = platforms.unix;
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ eelco ];
  };
}
