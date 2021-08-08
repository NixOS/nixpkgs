{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, libpcap
, openssl
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
      openssl_out = openssl.out;
    })
    # Without nonpriv.patch, pppd --version doesn't work when not run as root.
    ./nonpriv.patch
  ];

  buildInputs = [
    libpcap
    openssl
  ];

  postPatch = ''
    # strip is not found when cross compiling with seemingly no way to point
    # make to the right place, fixup phase will correctly strip
    # everything anyway so we remove it from the Makefiles
    for file in $(find -name Makefile.linux); do
      substituteInPlace "$file" --replace '$(INSTALL) -s' '$(INSTALL)'
      substituteInPlace "$file" --replace '-m 4550' '-m 550'
    done
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    make install
    install -D -m 755 scripts/{pon,poff,plog} $out/bin
    runHook postInstall
  '';

  postFixup = ''
    for tgt in pon poff plog; do
      substituteInPlace "$out/bin/$tgt" --replace "/usr/sbin" "$out/bin"
    done
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
