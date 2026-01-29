{
  lib,
  fetchFromGitHub,
  fetchpatch,
  mkCataclysm,
}:

mkCataclysm (finalAttrs: {
  version = "0.H";

  src = fetchFromGitHub {
    owner = "CleverRaven";
    repo = "Cataclysm-DDA";
    tag = "${finalAttrs.version}-RELEASE";
    hash = "sha256-ZCD5qgqYSX7sS+Tc1oNYq9soYwNUUuWamY2uXfLjGoY=";
  };

  patches = [
    # fix compilation of the vendored flatbuffers under gcc14
    (fetchpatch {
      name = "fix-flatbuffers-with-gcc14";
      url = "https://github.com/CleverRaven/Cataclysm-DDA/commit/1400b1018ff37196bd24ba4365bd50beb571ac14.patch";
      hash = "sha256-H0jct6lSQxu48eOZ4f8HICxo89qX49Ksw+Xwwtp7iFM=";
    })
    # Unconditionally look for translation files in $out/share/locale
    ./locale-path.patch
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

  meta = {
    changelog = "https://github.com/CleverRaven/Cataclysm-DDA/blob/${finalAttrs.version}/data/changelog.txt";
  };
})
