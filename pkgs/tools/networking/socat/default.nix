{ stdenv, fetchurl, openssl, readline, which, nettools }:

stdenv.mkDerivation rec {
  name = "socat-1.7.3.3";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "0jnhjijyq74g3wa4ph0am83z6vq7qna7ac0xqjma8s4197z3zmhd";
  };

  patches = stdenv.lib.optional stdenv.isDarwin ./speed-type-fix.patch;

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

  meta = {
    description = "A utility for bidirectional data transfer between two independent data channels";
    homepage = http://www.dest-unreach.org/socat/;
    repositories.git = git://repo.or.cz/socat.git;
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
