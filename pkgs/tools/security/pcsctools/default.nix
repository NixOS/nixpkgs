{ stdenv
, lib
, fetchurl
, makeWrapper
, pkg-config
, systemd
, dbus
, pcsclite
, wget
, coreutils
, perlPackages
}:

stdenv.mkDerivation rec {
  pname = "pcsc-tools";
  version = "1.6.0";

  src = fetchurl {
    url = "http://ludovic.rousseau.free.fr/softwares/pcsc-tools/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ZRyN10vLM9tMFpNc5dgN0apusgup1cS5YxoJgybvi58=";
  };

  postPatch = ''
    substituteInPlace ATR_analysis \
      --replace /usr/local/pcsc /etc/pcsc \
      --replace /usr/share/pcsc $out/share/pcsc
  '';

  buildInputs = [ dbus perlPackages.perl pcsclite ]
    ++ lib.optional stdenv.isLinux systemd;

  nativeBuildInputs = [ makeWrapper pkg-config ];

  postInstall = ''
    wrapProgram $out/bin/scriptor \
      --set PERL5LIB "${with perlPackages; makePerlPath [ pcscperl ]}"
    wrapProgram $out/bin/gscriptor \
      --set PERL5LIB "${with perlPackages; makePerlPath [ pcscperl GlibObjectIntrospection Glib Gtk3 Pango Cairo CairoGObject ]}"
    wrapProgram $out/bin/ATR_analysis \
      --set PERL5LIB "${with perlPackages; makePerlPath [ pcscperl ]}"
    wrapProgram $out/bin/pcsc_scan \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ coreutils wget ]}"

    install -Dm444 -t $out/share/pcsc smartcard_list.txt
  '';

  meta = with lib; {
    description = "Tools used to test a PC/SC driver, card or reader";
    homepage = "http://ludovic.rousseau.free.fr/softwares/pcsc-tools/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
