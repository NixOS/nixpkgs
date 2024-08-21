{ lib
, coreutils
, stdenv
, fetchFromGitLab
, fetchpatch
, getopt
, libcap
, gnused
, nixosTests
, testers
, autoreconfHook
, po4a
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.32.2";
  pname = "fakeroot";

  src = fetchFromGitLab {
    owner = "clint";
    repo = "fakeroot";
    rev = "upstream/${finalAttrs.version}";
    domain = "salsa.debian.org";
    hash = "sha256-j1qSMPNCtAxClqYqWkRNQmtxkitYi7g/9KtQ5XqcX3w=";
  };

  patches = lib.optionals stdenv.isLinux [
    ./einval.patch

    # patches needed for musl libc, borrowed from alpine packaging.
    # it is applied regardless of the environment to prevent patchrot
    (fetchpatch {
      name = "do-not-redefine-id_t.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/fakeroot/do-not-redefine-id_t.patch?id=f68c541324ad07cc5b7f5228501b5f2ce4b36158";
      sha256 = "sha256-i9PoWriSrQ7kLZzbvZT3Kq1oXzK9mTyBqq808BGepOw=";
    })
    (fetchpatch {
      name = "fakeroot-no64.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/fakeroot/fakeroot-no64.patch?id=f68c541324ad07cc5b7f5228501b5f2ce4b36158";
      sha256 = "sha256-NCDaB4nK71gvz8iQxlfaQTazsG0SBUQ/RAnN+FqwKkY=";
    })
    (fetchpatch {
      name = "addendum-charset-conversion.patch";
      url = "https://salsa.debian.org/clint/fakeroot/-/commit/b769fb19fd89d696a5e0fd70b974f833f6a0655a.patch";
      hash = "sha256-3z1g+xzlyTpa055kpsoumP/E8srDlZss6B7Fv5A0QkU=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook po4a ];
  buildInputs = lib.optional (!stdenv.isDarwin) libcap;

  postUnpack = ''
    sed -i \
      -e 's@getopt@${getopt}/bin/getopt@g' \
      -e 's@sed@${gnused}/bin/sed@g' \
      -e 's@kill@${coreutils}/bin/kill@g' \
      -e 's@/bin/ls@${coreutils}/bin/ls@g' \
      -e 's@cut@${coreutils}/bin/cut@g' \
      source/scripts/fakeroot.in
  '';

  postConfigure = ''
    pushd doc
    po4a -k 0 --variable "srcdir=../doc/" po4a/po4a.cfg
    popd
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
      # A lightweight *unit* test that exercises fakeroot and fakechroot together:
      nixos-etc = nixosTests.etc.test-etc-fakeroot;
    };
  };

  meta = {
    homepage = "https://salsa.debian.org/clint/fakeroot";
    description = "Give a fake root environment through LD_PRELOAD";
    mainProgram = "fakeroot";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
