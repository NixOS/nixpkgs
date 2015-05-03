{ stdenv, fetchgit, pkgs }:

stdenv.mkDerivation rec {
  version = "v17";
  name = "fastd-${version}";

  src = fetchgit {
    url = "git://git.universe-factory.net/fastd";
    rev = "refs/tags/${version}";
    sha256 = "5e07b1d20e97897fde646fee994e186966685e5bbaf8edf09feb2fd06ffbeaf6";
  };

  buildInputs = [ pkgs.libsodium pkgs.libcap pkgs.libuecc pkgs.json_c ];

  nativeBuildInputs = [ pkgs.cmake pkgs.bison pkgs.pkgconfig pkgs.doxygen ];

  buildPhase = ''
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D ENABLE_SYSTEMD=ON -D ENABLE_LTO=ON .
    make
  '';

  installPhase = ''
    make install
  '';

  meta = with stdenv.lib; {
    description = "Fast and Secure Tunneling Daemon";
    license = stdenv.lib.licenses.bsd2;
    homepage = "https://projects.universe-factory.net/projects/fastd/wiki";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ maintainers.abaldeau ];
  };
}
