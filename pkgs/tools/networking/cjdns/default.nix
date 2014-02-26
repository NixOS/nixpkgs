{ stdenv, fetchgit, cmake }:

let
  rev = "f7b02ac0cc";
in
stdenv.mkDerivation {
  name = "cjdns-20130620-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    url = "https://github.com/cjdelisle/cjdns.git";
    inherit rev;
    sha256 = "1580a62yhph62nv7q2jdqrbkyk9a9g5i17snibkxyykc7rili5zq";
  };

  preConfigure = ''
    sed -i -e '/toolchain.*CACHE/d' CMakeLists.txt
  '';

  doCheck = true;
  checkPhase = "ctest";

  buildInputs = [ cmake ];

  meta = {
    homepage = https://github.com/cjdelisle/cjdns;
    description = "Encrypted networking for regular people";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
