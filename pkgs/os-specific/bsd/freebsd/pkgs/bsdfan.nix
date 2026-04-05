{
  lib,
  fetchFromGitHub,
  fetchpatch,
  mkDerivation,
}:
mkDerivation {
  path = "...";
  pname = "bsdfan";
  version = "devel-2018";
  src = fetchFromGitHub {
    owner = "claudiozz";
    repo = "bsdfan";
    rev = "d8428a773ec4e0dd465b145fa701097e2f93d7cc";
    hash = "sha256-y4CYDJLXVn5+eZ+5akEYQvzv+Shv7He4fYOyaQAbNyQ=";
  };
  outputs = [
    "out"
    "debug"
  ];
  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/ca7665183b5ede6266650081b4fadfb5afa6561c/sysutils/bsdfan/files/patch-system.c";
      extraPrefix = "";
      hash = "sha256-VPO1S6KUuPOUhJ0U+MvI1Ksaa9t9aXtzrKgqfWtcHzo=";
    })
  ];

  postInstall = ''
    mkdir -p $out/etc
    cp bsdfan.conf $out/etc
  '';

  meta = {
    description = "A simple FreeBSD fan control utility for thinkpads";
    platforms = lib.platforms.freebsd;
    mainProgram = "bsdfan";
  };
}
