{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  autoreconfHook,
  python3,
  perl,
  libxslt,
  docbook_xsl,
  docbook_xml_dtd_42,
  libseccomp,
  installTests ? true,
  gnumake,
  which,
  debugBuild ? false,
  libunwind,
}:

stdenv.mkDerivation rec {
  pname = "sydbox-1";
  version = "2.2.0";

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ] ++ lib.optional installTests "installedTests";

  src = fetchurl {
    url = "https://git.exherbo.org/${pname}.git/snapshot/${pname}-${version}.tar.xz";
    sha256 = "0664myrrzbvsw73q5b7cqwgv4hl9a7vkm642s1r96gaxm16jk0z7";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    python3
    perl
    libxslt.bin
    docbook_xsl
    docbook_xml_dtd_42
  ];

  buildInputs =
    [
      libseccomp
    ]
    ++ lib.optional debugBuild libunwind
    ++ lib.optionals installTests [
      gnumake
      python3
      perl
      which
    ];

  enableParallelBuilding = true;

  configureFlags =
    [ ]
    ++ lib.optionals installTests [
      "--enable-installed-tests"
      "--libexecdir=${placeholder "installedTests"}/libexec"
    ]
    ++ lib.optional debugBuild "--enable-debug";

  makeFlags = [ "SYD_INCLUDEDIR=${stdenv.cc.libc.dev}/include" ];

  doCheck = true;
  checkPhase = ''
    # Many of the regular test cases in t/ do not work inside the build sandbox
    make -C syd check
  '';

  postInstall =
    if installTests then
      ''
        moveToOutput bin/syd-test $installedTests
      ''
    else
      ''
        # Tests are installed despite --disable-installed-tests
        rm -r $out/bin/syd-test $out/libexec
      '';

  meta = with lib; {
    homepage = "https://sydbox.exherbo.org/";
    description = "seccomp-based application sandbox";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mvs ];
  };
}
