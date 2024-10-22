{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "qqwing";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "stephenostermiller";
    repo = "qqwing";
    rev = "refs/tags/v${version}";
    hash = "sha256-MYHPANQk4aUuDqUNxWPbqw45vweZ2bBcUcMTyEjcAOM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    perl
  ];

  configureFlags = [
    "--prefix=${placeholder "out"}"
  ];

  buildFlags = [
    "cppcompile"
  ];

  postPatch = ''
    patchShebangs --build build/src-first-comment.pl build/src_neaten.pl

    substituteInPlace build/cpp_configure.sh \
      --replace-fail "./configure" "./configure $configureFlags"
    substituteInPlace build/cpp_install.sh \
      --replace-fail "sudo " ""
  '';

  meta = {
    homepage = "https://qqwing.com";
    description = "Sudoku generating and solving software";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "qqwing";
  };
}
