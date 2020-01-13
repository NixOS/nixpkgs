{ stdenv, fetchurl, substituteAll, libpcap, openssl }:

stdenv.mkDerivation rec {
  version = "2.4.7";
  pname = "ppp";

  src = fetchurl {
    url = "mirror://samba/ppp/${pname}-${version}.tar.gz";
    sha256 = "0c7vrjxl52pdwi4ckrvfjr08b31lfpgwf3pp0cqy76a77vfs7q02";
  };

  patches =
    [ ( substituteAll {
        src = ./nix-purity.patch;
        inherit libpcap;
        glibc = stdenv.cc.libc.dev or stdenv.cc.libc;
      })
      # Without nonpriv.patch, pppd --version doesn't work when not run as
      # root.
      ./nonpriv.patch
      (fetchurl {
        name = "CVE-2015-3310.patch";
        url = "https://salsa.debian.org/roam/ppp/raw/ef5d585aca6b1200a52c7109caa66ef97964d76e/debian/patches/rc_mksid-no-buffer-overflow";
        sha256 = "1dk00j7bg9nfgskw39fagnwv1xgsmyv0xnkd6n1v5gy0psw0lvqh";
      })
      (fetchurl {
        url = "https://salsa.debian.org/roam/ppp/raw/ef5d585aca6b1200a52c7109caa66ef97964d76e/debian/patches/0016-pppoe-include-netinet-in.h-before-linux-in.h.patch";
        sha256 = "1xnmqn02kc6g5y84xynjwnpv9cvrfn3nyv7h7r8j8xi7qf2aj4q8";
      })
      (fetchurl {
        url = https://www.nikhef.nl/~janjust/ppp/ppp-2.4.7-eaptls-mppe-1.102.patch;
        sha256 = "04war8l5szql53l36043hvzgfwqp3v76kj8brbz7wlf7vs2mlkia";
      })
      ./musl-fix-headers.patch
    ];

  buildInputs = [ libpcap openssl ];

  postPatch = ''
    # strip is not found when cross compiling with seemingly no way to point
    # make to the right place, fixup phase will correctly strip
    # everything anyway so we remove it from the Makefiles
    for file in $(find -name Makefile.linux); do
      substituteInPlace "$file" --replace '$(INSTALL) -s' '$(INSTALL)'
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

  meta = with stdenv.lib; {
    homepage = https://ppp.samba.org/;
    description = "Point-to-point implementation for Linux and Solaris";
    license = with licenses; [ bsdOriginal publicDomain gpl2 lgpl2 ];
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
