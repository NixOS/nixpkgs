{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  openssl,
  buildllvmsparse ? false,
  buildc2xml ? false,
  libllvm,
  libxml2,
  substituteAll,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smatch";
  version = "1.73";

  src = fetchFromGitHub {
    owner = "error27";
    repo = "smatch";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-Pv3bd2cjnQKnhH7TrkYWfDEeaq6u/q/iK1ZErzn6bME=";
  };

  patches = [
    (
      let
        clang-major = lib.versions.major (lib.getVersion llvmPackages.clang-unwrapped);
        clang-lib = lib.getLib llvmPackages.clang-unwrapped;
      in
      substituteAll {
        src = ./fix_include_path.patch;

        clang = "${clang-lib}/lib/clang/${clang-major}/include";
        libc = "${lib.getDev stdenv.cc.libc}/include";
      }
    )
  ];

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    sqlite
    openssl
  ] ++ lib.optionals buildllvmsparse [ libllvm ] ++ lib.optionals buildc2xml [ libxml2.dev ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  meta = {
    description = "Semantic analysis tool for C";
    homepage = "https://sparse.docs.kernel.org/";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
