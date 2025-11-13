{
  lib,
  fetchFromGitHub,
  mkCataclysm,
}:

mkCataclysm (finalAttrs: {
  pname = "cataclysm-dda-git";
  version = "2025-11-07-1337";

  src = fetchFromGitHub {
    owner = "CleverRaven";
    repo = "Cataclysm-DDA";
    tag = "cdda-experimental-${finalAttrs.version}";
    hash = "sha256-EnVN2OwWn8eWGaB/nYWxclKfU2H56plgQH32YNE6Xm4=";
  };

  patches = [
    ./locale-path-git.patch
  ];
  postPatch = ''
    patchShebangs lang/compile_mo.sh

    # Werror causes builds to fail on newer compilers
    substituteInPlace CMakeLists.txt Makefile \
      --replace-fail "-Werror" ""

    # The CMake build doesn't work without the git binary,
    # so just hardcode the version in regardless.
    substituteInPlace src/version.cpp \
      --replace-fail "return VERSION" 'return "${finalAttrs.version}"'
  '';

  makeFlags = [
    "VERSION=${finalAttrs.version}"
  ];

  meta = {
    maintainers = with lib.maintainers; [ rardiol ];
  };
})
