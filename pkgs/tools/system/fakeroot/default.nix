{
  lib,
  coreutils,
  stdenv,
  fetchurl,
  fetchpatch,
  getopt,
  libcap,
  gnused,
  nixosTests,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.29";
  pname = "fakeroot";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/f/fakeroot/fakeroot_${finalAttrs.version}.orig.tar.gz";
    sha256 = "sha256-j7uvt4DJFz46zkoEr7wdkA8zfzIWiDk59cfbNDG+fCA=";
  };

  patches = lib.optionals stdenv.isLinux [
    ./einval.patch
    (fetchpatch {
      name = "also-wrap-stat-library-call.patch";
      url = "https://sources.debian.org/data/main/f/fakeroot/1.29-1/debian/patches/also-wrap-stat-library-call.patch";
      sha256 = "0p7lq6m31k3rqsnjbi06a8ykdqa3cp4y5ngsjyk3q1269gx59x8b";
    })

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
  ];

  buildInputs = lib.optional (!stdenv.isDarwin) libcap;

  postUnpack = ''
    sed -i \
      -e 's@getopt@${getopt}/bin/getopt@g' \
      -e 's@sed@${gnused}/bin/sed@g' \
      -e 's@kill@${coreutils}/bin/kill@g' \
      -e 's@/bin/ls@${coreutils}/bin/ls@g' \
      -e 's@cut@${coreutils}/bin/cut@g' \
      fakeroot-${finalAttrs.version}/scripts/fakeroot.in
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
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ viric ];
    platforms = lib.platforms.unix;
  };
})
