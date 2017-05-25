{ stdenv, fetchgit, autoreconfHook, readline }:

let
  ell = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     rev = "58e873d7463f3a7f91e02260585bfa50cbc77668";
     sha256 = "12k1f1iarm29j8k16mhw83xx7r3bama4lp0fchhnj7iwxrpgs4gh";
  };
in stdenv.mkDerivation rec {
  name = "iwd-unstable-2017-04-21";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = "f64dea81b8490e5e09888be645a4325419bb269c";
    sha256 = "0maqhx5264ykgmwaf90s2806i1kx2028if34ph2axlirxrhdd3lg";
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
