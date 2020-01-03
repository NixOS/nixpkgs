{ stdenv, fetchurl, cmake, python2, boost, libuuid, ruby, buildEnv, buildPythonPackage, qpid-python }:

let
  name = "qpid-cpp-${version}";
  version = "1.38.0";

  src = fetchurl {
    url = "mirror://apache/qpid/cpp/${version}/${name}.tar.gz";
    sha256 = "1q7nsl9g8xv81ymhpkdp9mlw3gkzba62gggp3b72f0ywpc3kc3cz";
  };

  meta = with stdenv.lib; {
    homepage = http://qpid.apache.org;
    repositories.git = git://git.apache.org/qpid.git;
    repositories.svn = http://svn.apache.org/repos/asf/qpid;
    description = "An AMQP message broker and a C++ messaging API";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cpages ma27 ];
  };

  qpid-cpp = stdenv.mkDerivation {
    inherit src meta name;

    nativeBuildInputs = [ cmake ];
    buildInputs = [ boost libuuid ruby python2 ];

    # the subdir managementgen wants to install python stuff in ${python} and
    # the installation tries to create some folders in /var
    postPatch = ''
      sed -i '/managementgen/d' CMakeLists.txt
      sed -i '/ENV/d' src/CMakeLists.txt
      sed -i '/management/d' CMakeLists.txt
    '';

    NIX_CFLAGS_COMPILE = [
      "-Wno-error=deprecated-declarations"
      "-Wno-error=int-in-bool-context"
      "-Wno-error=maybe-uninitialized"
      "-Wno-error=unused-function"
      "-Wno-error=ignored-qualifiers"
      "-Wno-error=catch-value"
    ];
  };

  python-frontend = buildPythonPackage {
    inherit name meta src;

    sourceRoot = "${name}/management/python";

    propagatedBuildInputs = [ qpid-python ];
  };
in buildEnv {
  name = "${name}-env";
  paths = [ qpid-cpp python-frontend ];
}
