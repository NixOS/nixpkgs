## Brother MFC-J430W CUPS wrapper driver
#
# This is a dependency for the official Brother CUPS wrapper driver.
# It takes and extracts the Brother mfcj430wlpr deb package.
#
#
## Install the driver
# Using the standard method as indicated in
#  https://nixos.wiki/wiki/Printing
# by adding the following to the configuration.nix:
#
# {
#   ...
#   services.printing.enable = true;
#   services.printing.drivers = [ mfcj430w-cupswrapper ];
#   ...
# }
#
#
## Setup
#     URI example
#     ~  `lpd://BRW0080927AFBCE/binary_p1`
#     ~  `ipp://your-printer-ip-address:631/ipp`
#
#
## Testing
# . used on NixOS 20.09 with Cinnamon using system-config-printer
#


{ lib, stdenv, fetchurl, cups, dpkg, ghostscript, a2ps, coreutils, gnused, gawk, file, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "mfcj430w-cupswrapper";
  version = "3.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006570/mfcj430wlpr-${version}.i386.deb";
    sha256 = "0an3xq9gmml2dxwba6jk6m2aypaa8jii7lzqgk7y46acf5ar09da";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cups ghostscript dpkg a2ps ];

  dontUnpack = true;

  installPhase = ''
    dpkg-deb -x $src $out

    substituteInPlace $out/opt/brother/Printers/mfcj430w/lpd/filtermfcj430w \
    --replace /opt "$out/opt" \

    sed -i '/GHOST_SCRIPT=/c\GHOST_SCRIPT=gs' $out/opt/brother/Printers/mfcj430w/lpd/psconvertij2

    patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux.so.2 $out/opt/brother/Printers/mfcj430w/lpd/brmfcj430wfilter

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/mfcj430w/lpd/filtermfcj430w $out/lib/cups/filter/brother_lpdwrapper_mfcj430w

    wrapProgram $out/opt/brother/Printers/mfcj430w/lpd/psconvertij2 \
    --prefix PATH ":" ${ lib.makeBinPath [ gnused coreutils gawk ] }

    wrapProgram $out/opt/brother/Printers/mfcj430w/lpd/filtermfcj430w \
    --prefix PATH ":" ${ lib.makeBinPath [ ghostscript a2ps file gnused coreutils ] }
  '';

  meta = with lib; {
    homepage = "https://www.brother.com/";
    description = "Brother MFC-J430W LPR driver";
    license = licenses.unfree;
    platforms = platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj430w_all&os=128&autolayerclose=1";
    maintainers = with maintainers; [ svavs ];
  };
}
