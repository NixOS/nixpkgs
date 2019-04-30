{ stdenv, autoreconfHook, coreutils, fetchFromGitHub, fetchpatch, pkgconfig
# pyflame needs one python version per ABI
# are currently supported
# * 2.6 or 2.7 for 2.x ABI
# * 3.4 or 3.5 for 3.{4,5} ABI
# * 3.6        for 3.6 ABI
# * 3.7        for 3.7+ ABI
# to disable support for an ABI, make the corresponding argument null
, python2, python35, python36, python37, python3
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

  # Uber's abandoned this since Jun 2018, so we have to patch a lot.
  # Yay.
  patches = let
    # "Add support for Python3.7 (#151)":
    py37-support = [ # https://github.com/uber/pyflame/pull/153
      (fetchpatch { # "Add support for python3.7"
        url = "https://github.com/uber/pyflame/commit/5ee674c4b09a29b82a0e2d7a4ce064fea3df1f4c.patch";
        sha256 = "19v0yl8frbsq1dkvcmr1zsxf9v75bs8hvlkiv2x8cwylndvz2g5n";
      })
      (fetchpatch { # "Add python3.7 to travis test matrix"
        url = "https://github.com/uber/pyflame/commit/610b5281502ff6d57471e84071f17a33d30f3bcf.patch";
        sha256 = "13kwzrz0zwmdiirg061wvz7zvdl2w9dnrc81xbkxpm1hh8h0mi9z";
      })
      (fetchpatch { # "Update ppa and Ubuntu version"
        url = "https://github.com/uber/pyflame/commit/ec82a43c90da64815a87d4e3fe2a12ec3c93dc38.patch";
        sha256 = "1rrcsj5095ns5iyk6ij9kylv8hsrflxjld7b4s5dbpk8jqkf3ndi";
      })
      (fetchpatch { # "Clang-Format"
        url = "https://github.com/uber/pyflame/commit/fb81e40398d6209c38d49d0b6758d9581b3c2bba.patch";
        sha256 = "024namalrsai8ppl87lqsalfgd2fbqsnbkhpg8q93bvsdxldwc6r";
      })
    ];

    # "Fix pyflame for code compiled with ld -z separate-code":
    separate-code-support = [ # https://github.com/uber/pyflame/pull/170
      (fetchpatch { # "Fix for code compiled with ld -z separate-code"
        url = "https://github.com/uber/pyflame/commit/739a77d9b9abf9599f633d49c9ec98a201bfe058.patch";
        sha256 = "03xhdysr5s73bw3a7nj2h45dylj9a4c1f1i3xqm1nngpd6arq4y6";
      })
    ];

    # "Improve PtraceSeize error output"
    full-ptrace-seize-errors = [ # https://github.com/uber/pyflame/pull/152
      (fetchpatch { # "Print whole error output from PtraceSeize"
        url = "https://github.com/uber/pyflame/commit/4b0e2c1b442b0f0c6ac5f56471359cea9886aa0f.patch";
        sha256 = "0nkqs5zszf78cna0bavcdg18g7rdmn72li3091ygpkgxn77cnvis";
      })
      (fetchpatch { # "Print whole error for PtraceSeize"
        url = "https://github.com/uber/pyflame/commit/1abb23abe4912c4a27553f0b3b5c934753f41f6d.patch";
        sha256 = "07razp9rlq3s92j8a3iak3qk2h4x4xwz4y915h52ivvnxayscj89";
      })
    ];
  in stdenv.lib.concatLists [
    py37-support
    # Without this, tests will leak memory and run forever.
    separate-code-support
    full-ptrace-seize-errors
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ python37 python36 python2 python35 ];

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
    install -D utils/flame-chart-json $out/bin/flame-chart-json
  '';

  doCheck = true;
  # reproduces the logic of their test script, but without downloading pytest
  # from the internet with pip
  checkPhase = let inherit (stdenv) lib; in
    lib.concatMapStringsSep "\n" (python: ''
      set -x
      PYMAJORVERSION=${lib.substring 0 1 python.version} \
        PATH=${lib.makeBinPath [ coreutils ]}\
        PYTHONPATH= \
        ${python.pkgs.pytest}/bin/pytest tests/
      set +x
    '') (lib.filter (x: x != null) buildInputs);

  meta = with stdenv.lib; {
    description = "A ptracing profiler for Python ";
    longDescription = ''
      Pyflame is a high performance profiling tool that generates flame graphs
      for Python. Pyflame uses the Linux ptrace(2) system call to collect
      profiling information. It can take snapshots of the Python call stack
      without explicit instrumentation, meaning you can profile a program
      without modifying its source code.
    '';
    homepage = https://github.com/uber/pyflame;
    license = licenses.asl20;
    maintainers = [ maintainers.symphorien ];
    # arm: https://github.com/uber/pyflame/issues/136
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
