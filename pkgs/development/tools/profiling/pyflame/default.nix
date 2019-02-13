{ stdenv, fetchFromGitHub, autoreconfHook, coreutils, pkgconfig
# pyflame needs one python version per ABI
# are currently supported
# * 2.6 or 2.7 for 2.x ABI
# * 3.4 or 3.5 for 3.{4,5} ABI
# * 3.6        for 3.6+ ABI
# if you want to disable support for some ABI, make the corresponding argument null
, python2, python35, python36, python3
}:
stdenv.mkDerivation rec {
  pname = "pyflame";
  version = "1.6.7";
  src = fetchFromGitHub {
    owner = "uber";
    repo = "pyflame";
    rev = "v${version}";
    sha256 = "0hz1ryimh0w8zyxx4y8chcn54d6b02spflj5k9rcg26an2chkg2w";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ python36 python2 python35 ];

  postPatch = ''
    patchShebangs .
    # some tests will fail in the sandbox
    substituteInPlace tests/test_end_to_end.py \
      --replace 'skipif(IS_DOCKER' 'skipif(True'

    # don't use patchShebangs here to be explicit about the python version
    substituteInPlace utils/flame-chart-json \
      --replace '#!usr/bin/env python' '#!${python3.interpreter}'
  '';

  postInstall = ''
    install	-D utils/flame-chart-json $out/bin/flame-chart-json
  '';

  doCheck = true;
  # reproduces the logic of their test script, but without downloading pytest
  # from the internet with pip
  checkPhase = with stdenv.lib; concatMapStringsSep "\n" (python: ''
    set -x
    PYMAJORVERSION=${head (strings.stringToCharacters python.version)} \
      PATH=${makeBinPath [ coreutils ]}\
      PYTHONPATH= \
      ${python.pkgs.pytest}/bin/pytest tests/
    set +x
  '') (filter (x: x!=null) buildInputs);

  meta = with stdenv.lib; {
    description = "A ptracing profiler for Python ";
    longDescription = ''
      Pyflame is a high performance profiling tool that generates flame graphs for
      Python. Pyflame uses the Linux ptrace(2) system call to collect profiling
      information. It can take snapshots of the Python call stack without
      explicit instrumentation, meaning you can profile a program without
      modifying its source code.
    '';
    homepage = https://github.com/uber/pyflame;
    license = licenses.asl20;
    maintainers = [ maintainers.symphorien ];
    # arm: https://github.com/uber/pyflame/issues/136
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
