{ lib
, stdenv
, fetchurl
, fetchpatch
, getopt
, ksh
, tzdata
, pkgsMusl # for passthru.tests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bmake";
  version = "20220928";

  src = fetchurl {
    url = "http://www.crufty.net/ftp/pub/sjg/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-yAS3feP+uOMd7ipMn7Hp7CTFo0dk56KBXIi07QFlDpA=";
  };

  # Make tests work with musl
  # * Disable deptgt-delete_on_error test (alpine does this too)
  # * Disable shell-ksh test (ksh doesn't compile with musl)
  # * Fix test failing due to different strerror(3) output for musl and glibc
  postPatch = lib.optionalString (stdenv.hostPlatform.libc == "musl") ''
    sed -i unit-tests/Makefile \
      -e '/deptgt-delete_on_error/d' \
      -e '/shell-ksh/d'
    substituteInPlace unit-tests/opt-chdir.exp --replace "File name" "Filename"
  '';

  nativeBuildInputs = [ getopt ];

  patches = [
    # make bootstrap script aware of the prefix in /nix/store
    ./bootstrap-fix.patch
    # preserve PATH from build env in unit tests
    ./fix-unexport-env-test.patch
    # Always enable ksh test since it checks in a impure location /bin/ksh
    ./unconditional-ksh-test.patch
    # decouple tests from build phase
    (fetchpatch {
      name = "separate-tests.patch";
      url = "https://raw.githubusercontent.com/alpinelinux/aports/2a36f7b79df44136c4d2b8e9512f908af65adfee/community/bmake/separate-tests.patch";
      hash = "sha256-KkmqASAl46/6Of7JLOQDFUqkOw3rGLxnNmyg7Lk0RwM=";
    })
    # add a shebang to bmake's install(1) replacement
    (fetchpatch {
      name = "install-sh.patch";
      url = "https://raw.githubusercontent.com/alpinelinux/aports/34cd8c45397c63c041cf3cbe1ba5232fd9331196/community/bmake/install-sh.patch";
      hash = "sha256-RvFq5nsmDxq54UTnXGlfO6Rip/XQYj0ZySatqUxjEX0=";
    })
  ];

  # The generated makefile is a small wrapper for calling ./boot-strap with a
  # given op. On a case-insensitive filesystem this generated makefile clobbers
  # a distinct, shipped, Makefile and causes infinite recursion during tests
  # which eventually fail with "fork: Resource temporarily unavailable"
  configureFlags = [
    "--without-makefile"
  ];

  # Disabled tests:
  # opt-chdir: ofborg complains about it somehow
  # opt-keep-going-indirect: not yet known
  # varmod-localtime: musl doesn't support TZDIR and this test relies on impure,
  # implicit paths
  BROKEN_TESTS = builtins.concatStringsSep " " [
    "opt-chdir"
    "opt-keep-going-indirect"
    "varmod-localtime"
  ];

  buildPhase = ''
    runHook preBuild

    ./boot-strap --prefix=$out -o . op=build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./boot-strap --prefix=$out -o . op=install

    runHook postInstall
  '';

  doCheck = true;

  nativeCheckInputs = [
    tzdata
  ] ++ lib.optionals (stdenv.hostPlatform.libc != "musl") [
    ksh
  ];

  checkPhase = ''
    runHook preCheck

    ./boot-strap -o . op=test

    runHook postCheck
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = "http://www.crufty.net/help/sjg/bmake.html";
    description = "Portable version of NetBSD 'make'";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thoughtpolice AndersonTorres ];
    platforms = platforms.unix;
  };

  passthru.tests.bmakeMusl = pkgsMusl.bmake;
})
# TODO: report the quirks and patches to bmake devteam (especially the Musl one)
