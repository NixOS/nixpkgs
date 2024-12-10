{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  libxcrypt,
  pkg-config,
  autoreconfHook,
  openssl,
  bash,
  nixosTests,
}:

stdenv.mkDerivation rec {
  version = "2.5.0";
  pname = "ppp";

  src = fetchFromGitHub {
    owner = "ppp-project";
    repo = pname;
    rev = "ppp-${version}";
    sha256 = "sha256-J7udiLiJiJ1PzNxD+XYAUPXZ+ABGXt2U3hSFUWJXe94=";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-openssl=${openssl.dev}"
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libpcap
    libxcrypt
    openssl
    bash
  ];

  postPatch = ''
    for file in $(find -name Makefile.linux); do
      substituteInPlace "$file" --replace '-m 4550' '-m 550'
    done

    patchShebangs --host \
      scripts/{pon,poff,plog}
  '';

  enableParallelBuilding = true;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  NIX_LDFLAGS = "-lcrypt";

  installFlags = [
    "sysconfdir=$(out)/etc"
  ];

  postInstall = ''
    install -Dm755 -t $out/bin scripts/{pon,poff,plog}
  '';

  postFixup = ''
    substituteInPlace "$out/bin/pon" --replace "/usr/sbin" "$out/bin"
  '';

  passthru.tests = {
    inherit (nixosTests) pppd;
  };

  meta = with lib; {
    homepage = "https://ppp.samba.org";
    description = "Point-to-point implementation to provide Internet connections over serial lines";
    license = with licenses; [
      bsdOriginal
      publicDomain
      gpl2Only
      lgpl2
    ];
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
