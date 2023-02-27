{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, colorama
, libunwind
, pytz
, requests
, six
}:

buildPythonPackage rec {
  version = "0.4.15";
  pname = "vmprof";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a2d872a40196404386d1e0d960e97b37c86c3f72a4f9d5a2b5f9ca1adaff5b62";
  };

  buildInputs = [ libunwind ];
  propagatedBuildInputs = [ colorama requests six pytz ];

  # No tests included
  doCheck = false;
  pythonImportsCheck = [ "vmprof" ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: src/vmprof_unix.o:src/vmprof_common.h:92: multiple definition of
  #     `_PyThreadState_Current'; src/_vmprof.o:src/vmprof_common.h:92: first defined here
  # TODO: can be removed once next release contains:
  #   https://github.com/vmprof/vmprof-python/pull/203
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "A vmprof client";
    license = licenses.mit;
    homepage = "https://vmprof.readthedocs.org/";
  };
}
