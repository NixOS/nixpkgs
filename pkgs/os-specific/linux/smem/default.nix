{
  lib,
  stdenv,
  fetchurl,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "smem";
  version = "1.5";

  src = fetchurl {
    url = "https://selenic.com/repo/smem/archive/${version}.tar.bz2";
    sha256 = "19ibv1byxf2b68186ysrgrhy5shkc5mc69abark1h18yigp3j34m";
  };

  buildInputs = [ python3 ];

  makeFlags = [ "smemcap" ];

  installPhase = ''
    install -Dm555 -t $out/bin/ smem smemcap
    install -Dm444 -t $out/share/man/man8/ smem.8
  '';

  meta = {
    homepage = "https://www.selenic.com/smem/";
    description = "A memory usage reporting tool that takes shared memory into account";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco ];
    license = lib.licenses.gpl2Plus;
  };
}
