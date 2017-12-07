{ stdenv, fetchgit, autoreconfHook, readline }:

let
  ell = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     rev = "58e873d7463f3a7f91e02260585bfa50cbc77668";
     sha256 = "12k1f1iarm29j8k16mhw83xx7r3bama4lp0fchhnj7iwxrpgs4gh";
  };
in stdenv.mkDerivation rec {
  name = "iwd-unstable-2017-06-02";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = "6c64ae34619bf7f18cba007d8b0374badbe7c17e";
    sha256 = "19rkf6lk213hdfs40ija7salars08zw6k5i5djdlpcn1j6y69i36";
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
