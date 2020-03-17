{ stdenv, fetchurl, fetchpatch, fetchFromGitHub, substituteAll, libpcap, openssl }:

stdenv.mkDerivation rec {
  version = "2.4.8";
  pname = "ppp";

  src = fetchFromGitHub {
    owner = "paulusmack";
    repo = "ppp";
    rev = "ppp-${version}";
    sha256 = "1i88m79h6g3fzsb4yw3k8bq1grsx3hsyawm7id2vcaab0gfqzjjv";
  };

  patches =
    [
      ( substituteAll {
        src = ./nix-purity.patch;
        inherit libpcap;
        glibc = stdenv.cc.libc.dev or stdenv.cc.libc;
        openssl = openssl.dev;
      })
      # Without nonpriv.patch, pppd --version doesn't work when not run as
      # root.
      ./nonpriv.patch
      (fetchpatch {
        name = "CVE-2015-3310.patch";
        url = "https://github.com/paulusmack/ppp/commit/858976b1fc3107f1261aae337831959b511b83c2.patch";
        sha256 = "0wirmcis67xjwllqhz9lsz1b7dcvl8shvz78lxgybc70j2sv7ih4";
      })
      (fetchurl {
        url = https://www.nikhef.nl/~janjust/ppp/ppp-2.4.7-eaptls-mppe-1.102.patch;
        sha256 = "04war8l5szql53l36043hvzgfwqp3v76kj8brbz7wlf7vs2mlkia";
      })
      (fetchpatch {
        name = "CVE-2020-8597.patch";
        url = "https://github.com/paulusmack/ppp/commit/8d7970b8f3db727fe798b65f3377fe6787575426.patch";
        sha256 = "129wnhwxmzvr3y9gzxv82jnb5y8m4yg8vkpa0xl2rwkl8anbzgkh";
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

  meta = with stdenv.lib; {
    homepage = https://ppp.samba.org/;
    description = "Point-to-point implementation for Linux and Solaris";
    license = with licenses; [ bsdOriginal publicDomain gpl2 lgpl2 ];
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
