{ stdenv
, lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, colorama
, libunwind
, pytz
, requests
, six
}:

buildPythonPackage rec {
  version = "0.4.15";
  format = "setuptools";
  pname = "vmprof";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a2d872a40196404386d1e0d960e97b37c86c3f72a4f9d5a2b5f9ca1adaff5b62";
  };

  buildInputs = [ libunwind ];
  propagatedBuildInputs = [ colorama requests six pytz ];

  patches = [
    (fetchpatch {
      name = "${pname}-python-3.10-compat.patch";
      # https://github.com/vmprof/vmprof-python/pull/198
      url = "https://github.com/vmprof/vmprof-python/commit/e4e99e5aa677f96d1970d88c8a439f995f429f85.patch";
      hash = "sha256-W/c6WtVuKi7xO2sCOr71mrZTWqI86bWg5a0FeDNolh0=";
    })
    (fetchpatch {
      name = "${pname}-python-3.11-compat.patch";
      # https://github.com/vmprof/vmprof-python/pull/251 (not yet merged)
      url = "https://github.com/matthiasdiener/vmprof-python/compare/a1a1b5264ec0b197444c0053e44f8ae4ffed9353...13c39166363b960017393b614270befe01230be8.patch";
      excludes = [ "test_requirements.txt" ];
      hash = "sha256-3+0PVdAf83McNd93Q9dD4HLXt39UinVU5BA8jWfT6F4=";
    })
  ];

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
