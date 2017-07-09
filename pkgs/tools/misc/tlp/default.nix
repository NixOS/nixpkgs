{ stdenv, lib, fetchFromGitHub, perl, makeWrapper, file, systemd, iw, rfkill
, hdparm, ethtool, inetutils , kmod, pciutils, smartmontools
, x86_energy_perf_policy, gawk, gnugrep, coreutils, utillinux
, enableRDW ? false, networkmanager
}:

let
  paths = lib.makeBinPath
          ([ iw rfkill hdparm ethtool inetutils systemd kmod pciutils smartmontools
             x86_energy_perf_policy gawk gnugrep coreutils utillinux
           ]
           ++ lib.optional enableRDW networkmanager
          );

in stdenv.mkDerivation rec {
  name = "tlp-${version}";
  version = "1.0";

  src = fetchFromGitHub {
        owner = "linrunner";
        repo = "TLP";
        rev = "${version}";
        sha256 = "0gq1y1qnzwyv7cw32g4ymlfssi2ayrbnd04y4l242k6n41d05bij";
      };

  makeFlags = [ "DESTDIR=$(out)"
                "TLP_SBIN=$(out)/bin"
                "TLP_BIN=$(out)/bin"
                "TLP_TLIB=$(out)/share/tlp-pm"
                "TLP_PLIB=$(out)/lib/pm-utils"
                "TLP_ULIB=$(out)/lib/udev"
                "TLP_NMDSP=$(out)/etc/NetworkManager/dispatcher.d"
                "TLP_SHCPL=$(out)/share/bash-completion/completions"
                "TLP_MAN=$(out)/share/man"

                "TLP_NO_INIT=1"
                "TLP_NO_PMUTILS=1"
              ];

  nativeBuildInputs = [ makeWrapper file ];

  buildInputs = [ perl ];

  installTargets = [ "install-tlp" "install-man" ] ++ stdenv.lib.optional enableRDW "install-rdw";

  postInstall = ''
    cp -r $out/$out/* $out
    rm -rf $out/$(echo "$NIX_STORE" | cut -d "/" -f2)

    for i in $out/bin/* $out/lib/udev/tlp-* ${lib.optionalString enableRDW "$out/etc/NetworkManager/dispatcher.d/*"}; do
      if file "$i" | grep -q Perl; then
        # Perl script; use wrapProgram
        wrapProgram "$i" \
          --prefix PATH : "${paths}"
      else
        # Bash script
        sed -i '2iexport PATH=${paths}:$PATH' "$i"
      fi
    done
  '';

  meta = with stdenv.lib; {
    description = "Advanced Power Management for Linux";
    homepage = "http://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html";
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl2Plus;
  };
}
