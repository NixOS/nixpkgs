{ stdenv, fetchurl, cmake, python, boost, libuuid, ruby }:

stdenv.mkDerivation rec {
  name = "${project}-cpp-${version}";

  project = "qpid";
  version = "0.26";

  src = fetchurl {
    url = "mirror://apache/${project}/${version}/${name}.tar.gz";
    sha256 = "1c03yi19d5h5h78h37add9csmy0mzvvmvn7zkcalwszabdhsb5yk";
  };

  buildInputs = [ cmake python boost boost.lib libuuid ruby ];

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
