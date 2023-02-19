{ lib
, stdenv
, fetchFromGitHub
, libpcap
, libxcrypt
, pkg-config
, autoreconfHook
, openssl
, bash
, nixosTests
, writeTextDir
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
    "--with-openssl=${openssl.dev}"
    "--sysconfdir=/etc"
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

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  NIX_LDFLAGS = "-lcrypt";

  installFlags = [
    "sysconfdir=$(out)/etc"
  ];

  preInstall = ''
    mkdir -p $out/bin
  '';
  postInstall = ''
    install -D -m 755 scripts/{pon,poff,plog} $out/bin
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
      gpl2
      lgpl2
    ];
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
