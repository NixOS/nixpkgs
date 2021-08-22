{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, buildPackages
, pkg-config
, libusb-compat-0_1
, readline
, libewf
, perl
, zlib
, openssl
, libuv
, file
, libzip
, xxHash
, gtk2
, vte
, gtkdialog
, python3
, ruby
, lua
, capstone
, useX11 ? false
, rubyBindings ? false
, pythonBindings ? false
, luaBindings ? false
}:

stdenv.mkDerivation rec {
  pname = "radare2";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "radare";
    repo = "radare2";
    rev = version;
    sha256 = "sha256-VS8eG5RXwKtJSLmyaSifopJU7WYGMUcznn+burPqEYE=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-3673.patch";
      url = "https://github.com/radareorg/radare2/commit/d7ea20fb2e1433ebece9f004d87ad8f2377af23d.patch";
      sha256 = "14vr2chcyx9xrb1krczppwy619fb3k5dnyc4mcg40mvfl70ndbwn";
    })
  ];

  postInstall = ''
    install -D -m755 $src/binr/r2pm/r2pm $out/bin/r2pm
  '';

  WITHOUT_PULL = "1";
  makeFlags = [
    "GITTAP=${version}"
    "RANLIB=${stdenv.cc.bintools.bintools}/bin/${stdenv.cc.bintools.targetPrefix}ranlib"
  ];
  configureFlags = [
    "--with-sysmagic"
    "--with-syszip"
    "--with-sysxxhash"
    "--with-syscapstone"
    "--with-openssl"
  ];

  enableParallelBuilding = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    capstone
    file
    readline
    libusb-compat-0_1
    libewf
    perl
    zlib
    openssl
    libuv
  ] ++ lib.optional useX11 [ gtkdialog vte gtk2 ]
    ++ lib.optional rubyBindings [ ruby ]
    ++ lib.optional pythonBindings [ python3 ]
    ++ lib.optional luaBindings [ lua ];

  propagatedBuildInputs = [
    # radare2 exposes r_lib which depends on these libraries
    file # for its list of magic numbers (`libmagic`)
    libzip
    xxHash
  ];

  meta = {
    description = "unix-like reverse engineering framework and commandline tools";
    homepage = "http://radare.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ raskin makefu mic92 ];
    platforms = with lib.platforms; linux;
    inherit version;
  };
}
