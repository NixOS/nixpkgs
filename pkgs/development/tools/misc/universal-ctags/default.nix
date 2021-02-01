{ lib, stdenv, fetchFromGitHub, autoreconfHook, coreutils, pkg-config, perl, python3Packages, libiconv, jansson }:

stdenv.mkDerivation rec {
  pname = "universal-ctags";
  version = "5.9.20201206.0";

  src = fetchFromGitHub {
    owner = "universal-ctags";
    repo = "ctags";
    rev = "p${version}";
    sha256 = "0w10zjyz46sjm6ypxmq550dkr84hvc4phm4vm9j53jp5s19x5q19";
  };

  nativeBuildInputs = [ autoreconfHook coreutils pkg-config python3Packages.docutils ];
  buildInputs = [ jansson ] ++ lib.optional stdenv.isDarwin libiconv;

  # to generate makefile.in
  autoreconfPhase = ''
    ./autogen.sh
  '';

  configureFlags = [ "--enable-tmpdir=/tmp" ];

  postPatch = ''
    # Remove source of non-determinism
    substituteInPlace main/options.c \
      --replace "printf (\"  Compiled: %s, %s\n\", __DATE__, __TIME__);" ""

    substituteInPlace Tmain/utils.sh \
      --replace /bin/echo ${coreutils}/bin/echo
  '';

  postConfigure = ''
    sed -i 's|/usr/bin/env perl|${perl}/bin/perl|' misc/optlib2c
  '';

  doCheck = true;

  checkFlags = [ "units" ];

  meta = with lib; {
    description = "A maintained ctags implementation";
    homepage = "https://ctags.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    # universal-ctags is preferred over emacs's ctags
    priority = 1;
    maintainers = [ maintainers.mimame ];
  };
}
