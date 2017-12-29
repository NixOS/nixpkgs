{ stdenv, fetchgit, autoreconfHook, readline }:

let
  ell = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     rev = "e0dbdfbd5992bd3e78029b83930b9020e74cdaa5";
     sha256 = "031m1vvcrhggnyvvqyrqpzldi2amsbvhdfcxrypzqz58vysk69vm";
  };
in stdenv.mkDerivation rec {
  name = "iwd-unstable-2017-09-22";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = "31631e1935337910c7bc0c3eb215f579143c1fe0";
    sha256 = "0xl8ali5hy7ragdc4palm857y0prcg32294hv3vv28r9r4x4llcm";
  };

  configureFlags = [
    "--with-dbusconfdir=$(out)/etc/"
  ];

  postUnpack = ''
    ln -s ${ell} ell
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ readline ];

  meta = with stdenv.lib; {
    homepage = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    description = "Wireless daemon for Linux";
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
