{ lib, stdenv, fetchurl, fetchgit, autoreconfHook, dejagnu, elfutils }:

stdenv.mkDerivation rec {
  pname = "ltrace";
  version = "0.7.91";

  src = fetchurl {
    url = "https://src.fedoraproject.org/repo/pkgs/ltrace/ltrace-0.7.91.tar.bz2/9db3bdee7cf3e11c87d8cc7673d4d25b/ltrace-0.7.91.tar.bz2";
    sha256 = "sha256-HqellbKh2ZDHxslXl7SSIXtpjV1sodtgVwh8hgTC3Dc=";
  };

  nativeBuildInputs = [ autoreconfHook ];  # Some patches impact ./configure.
  buildInputs = [ elfutils ];
  nativeCheckInputs = [ dejagnu ];

  # Import Fedora's (very) large patch series: bug fixes, architecture support,
  # etc. RH/Fedora are currently working with upstream to merge all these
  # patches for the next major branch.
  prePatch = let
      fedora = fetchgit {
        url = "https://src.fedoraproject.org/rpms/ltrace.git";
        rev = "00f430ccbebdbd13bdd4d7ee6303b091cf005542";
        sha256 = "sha256-FBGEgmaslu7xrJtZ2WsYwu9Cw1ZQrWRV1+Eu9qLXO4s=";
      };
    in ''
      # Order matters, read the patch list from the RPM spec. Our own patches
      # are applied on top of the Fedora baseline.
      fedorapatches=""
      for p in $(grep '^Patch[0-9]\+:' ${fedora}/ltrace.spec | awk '{ print $2 }'); do
        fedorapatches="$fedorapatches ${fedora}/$p"
      done
      patches="$fedorapatches $patches"
    '';

  # Cherry-pick extra patches for recent glibc support in the test suite.
  patches = [
    # https://gitlab.com/cespedes/ltrace/-/merge_requests/14
    ./testsuite-newfstatat.patch
    # https://gitlab.com/cespedes/ltrace/-/merge_requests/15
    ./sysdeps-x86.patch
  ];

  doCheck = true;
  checkPhase = ''
    # Hardening options interfere with some of the low-level expectations in
    # the test suite (e.g. printf ends up redirected to __printf_chk).
    NIX_HARDENING_ENABLE="" \
    # Disable test that requires ptrace-ing a non-child process, this might be
    # forbidden by YAMA ptrace policy on the build host.
    RUNTESTFLAGS="--host=${stdenv.hostPlatform.config} \
                  --target=${stdenv.targetPlatform.config} \
                  --ignore attach-process.exp" \
      make check
  '';

  meta = with lib; {
    description = "Library call tracer";
    mainProgram = "ltrace";
    homepage = "https://www.ltrace.org/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
