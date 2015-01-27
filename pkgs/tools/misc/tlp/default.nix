{ stdenv, fetchFromGitHub, makeWrapper, perl, systemd, iw, rfkill, hdparm, ethtool, inetutils, kmod
, enableRDW ? true, networkmanager }:

let version = "0.6";
in stdenv.mkDerivation {
  inherit enableRDW;

  name = "tlp-${version}";

  src = fetchFromGitHub {
        owner = "linrunner";
        repo = "TLP";
        rev = "${version}";
        sha256 = "1kfm6x5w9vica2i13vfckza4fad4wv8ivr40fws3qa6d5jbyx0fy";
      };

  makeFlags = [ "DESTDIR=$(out)"
                "TLP_LIBDIR=/lib"
                "TLP_SBIN=/bin"
                "TLP_BIN=/bin"
                "TLP_NO_INIT=1"
                "TLP_NO_PMUTILS=1"
              ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  paths = with stdenv.lib;
          concatMapStringsSep ":" (x: "${x}/bin")
          ([ iw rfkill hdparm ethtool inetutils systemd kmod ]
           ++ optional enableRDW networkmanager
          );

  installTargets = [ "install-tlp" ] ++ stdenv.lib.optional enableRDW "install-rdw";

  postInstall = ''
    for i in $out/bin/* $out/lib/udev/tlp-*; do
      sed -i "s,/usr/lib/,$out/lib/,g" "$i"
      wrapProgram "$i" \
        --prefix PATH : "$paths"
    done
    if [ "$enableRDW" = "1" ]; then
      for i in $out/etc/NetworkManager/dispatcher.d/*; do
        sed -i "s,/usr/lib/,$out/lib/,g" "$i"
        wrapProgram "$i" \
          --prefix PATH : "$paths"
      done
    fi

    for i in $out/lib/udev/rules.d/*; do
      sed -i "s,RUN+=\",\\0$out,g; s,/usr/sbin,/bin,g" "$i"
    done
  '';

  passthru = { inherit enableRDW; };

  meta = with stdenv.lib; {
    description = "Advanced Power Management for Linux";
    homepage = "http://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html";
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl2Plus;
  };
}
