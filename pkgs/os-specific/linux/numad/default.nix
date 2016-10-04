{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "numad-0.5";

  src = fetchurl {
    url = "https://git.fedorahosted.org/cgit/numad.git/snapshot/${name}.tar.xz";
    sha256 = "08zd1yc3w00yv4mvvz5sq1gf91f6p2s9ljcd72m33xgnkglj60v4";
  };

  hardeningDisable = [ "format" ];

  patches = [
    ./numad-linker-flags.patch
  ];
  postPatch = ''
    substituteInPlace Makefile --replace "install -m" "install -Dm"
  '';

  makeFlags = "prefix=$(out)";

  meta = with stdenv.lib; {
    description = "A user-level daemon that monitors NUMA topology and processes resource consumption to facilitate good NUMA resource access";
    homepage = https://fedoraproject.org/wiki/Features/numad;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ domenkozar ];
  };
}
