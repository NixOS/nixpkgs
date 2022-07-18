{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, libpcap
, openssl
, bash
}:

stdenv.mkDerivation rec {
  version = "2.4.9";
  pname = "ppp";

  src = fetchFromGitHub {
    owner = "ppp-project";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-8+nbqRNfKPLDx+wmuKSkv+BSeG72hKJI4dNqypqeEK4=";
  };

  patches = [
    (substituteAll {
      src = ./nix-purity.patch;
      glibc = stdenv.cc.libc.dev or stdenv.cc.libc;
      openssl_dev = openssl.dev;
      openssl_lib = lib.getLib openssl;
    })
    # Without nonpriv.patch, pppd --version doesn't work when not run as root.
    ./nonpriv.patch
  ];

  buildInputs = [
    libpcap
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

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    make install
    install -D -m 755 scripts/{pon,poff,plog} $out/bin
    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace "$out/bin/pon" --replace "/usr/sbin" "$out/bin"
  '';

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
