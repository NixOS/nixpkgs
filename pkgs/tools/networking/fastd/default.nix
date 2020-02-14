{ stdenv, fetchgit, cmake, bison, pkgconfig
, libuecc, libsodium, libcap, json_c }:

stdenv.mkDerivation rec {
  version = "18";
  pname = "fastd";

  src = fetchgit {
    url = "git://git.universe-factory.net/fastd";
    rev = "refs/tags/v${version}";
    sha256 = "0c9v3igv3812b3jr7jk75a2np658yy00b3i4kpbpdjgvqzc1jrq8";
  };

  postPatch = ''
    substituteInPlace src/crypto/cipher/CMakeLists.txt \
      --replace 'add_subdirectory(aes128_ctr)' ""
  '';

  nativeBuildInputs = [ pkgconfig bison cmake ];
  buildInputs = [ libuecc libsodium libcap json_c ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Fast and Secure Tunneling Daemon";
    homepage = https://projects.universe-factory.net/projects/fastd/wiki;
    license = with licenses; [ bsd2 bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
