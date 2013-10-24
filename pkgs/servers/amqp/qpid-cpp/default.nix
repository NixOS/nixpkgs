{ stdenv, fetchurl, cmake, python, boost, libuuid }:

stdenv.mkDerivation rec {
  name = "${project}-cpp-${version}";

  project = "qpid";
  version = "0.24";

  src = fetchurl {
    url = "mirror://apache/${project}/${version}/${name}.tar.gz";
    sha256 = "08nfks5jjipy5i4b6mz62ijrz5ryq32c478ix7l3fzmaim3cy8b8";
  };

  buildInputs = [ cmake python boost libuuid ];

  # workaround this
  #/nix/store/n38ns73bm4iv62fihd9ih5b39w54yyaf-boost-1.54.0/include/boost/ptr_container/detail/map_iterator.hpp:52:48:
  #error: type qualifiers ignored on function return type [-Werror=ignored-qualifiers]
  cmakeFlags = "-DENABLE_WARNINGS=OFF";

  # the subdir managementgen wants to install python stuff in ${python} and
  # the installation tries to create some folders in /var
  patchPhase = ''
    sed -i '/managementgen/d' CMakeLists.txt
    sed -i '/ENV/d' src/CMakeLists.txt
  '';

  meta = {
    homepage = http://qpid.apache.org;
    repositories.git = git://git.apache.org/qpid.git;
    repositories.svn = http://svn.apache.org/repos/asf/qpid;
    description = "An AMQP message broker and a C++ messaging API";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.page ];
  };
}
