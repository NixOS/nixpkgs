{ stdenv, lib, fetchFromGitHub, perl, makeWrapper, systemd, iw, rfkill, hdparm, ethtool, inetutils
, kmod, pciutils, smartmontools, x86_energy_perf_policy, gawk, gnugrep, coreutils
, enableRDW ? false, networkmanager
}:

let
  paths = lib.makeBinPath
          ([ iw rfkill hdparm ethtool inetutils systemd kmod pciutils smartmontools
             x86_energy_perf_policy gawk gnugrep coreutils
           ]
           ++ lib.optional enableRDW networkmanager
          );

in stdenv.mkDerivation rec {
  name = "tlp-${version}";
  version = "0.8";

  src = fetchFromGitHub {
        owner = "linrunner";
        repo = "TLP";
        rev = "${version}";
        sha256 = "19fvk0xz6i2ryf41akk4jg1c4sb4rcyxdl9fr0w4lja7g76d5zww";
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

  installTargets = [ "install-tlp" ] ++ stdenv.lib.optional enableRDW "install-rdw";

  postInstall = ''
    for i in $out/bin/* $out/lib/udev/tlp-*; do
      sed -i "s,/usr/lib/,$out/lib/,g" "$i"
      if [[ "$(basename "$i")" = tlp-*list ]]; then
        # Perl script; use wrapProgram
        wrapProgram "$i" \
          --prefix PATH : "${paths}"
      else
        # Bash script
        sed -i '2iexport PATH=${paths}:$PATH' "$i"
      fi
    done

    for i in $out/lib/udev/rules.d/*; do
      sed -i "s,RUN+=\",\\0$out,g; s,/usr/sbin,/bin,g" "$i"
    done

    for i in man/*; do
      install -D $i $out/share/man/man''${i##*.}/$(basename $i)
    done
  '' + lib.optionalString enableRDW ''
    for i in $out/etc/NetworkManager/dispatcher.d/*; do
      sed -i \
        -e "s,/usr/lib/,$out/lib/,g" \
        -e '2iexport PATH=${paths}:$PATH' \
        "$i"
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
