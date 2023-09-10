{ lib, stdenv, fetchurl, tcp_wrappers, flex, bison, perl, libnsl }:

stdenv.mkDerivation rec {
  pname = "tacacsplus";
  version = "4.0.4.28";

  src = fetchurl {
    url = "ftp://ftp.shrubbery.net/pub/tac_plus/tacacs-F${version}.tar.gz";
    sha256 = "17i18z3s58c8yy8jxp01q3hzz5nirs4cjxms18zzkli6ip4jszql";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ tcp_wrappers perl libnsl ];

  meta = with lib; {
    description = "A protocol for authentication, authorization and accounting (AAA) services for routers and network devices";
    homepage = "http://www.shrubbery.net/tac_plus/";
    license = licenses.free;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = with platforms; linux;
  };
}
