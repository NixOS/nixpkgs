{
  lib,
  stdenv,
  fetchurl,
  pkgsi686Linux,
  dpkg,
  makeWrapper,
  coreutils,
  gnused,
  gawk,
  file,
  cups,
  util-linux,
  xxd,
  runtimeShell,
  ghostscript,
  a2ps,
}:

# Why:
# The executable "brprintconf_mfcj6510dw" binary is looking for "/opt/brother/Printers/%s/inf/br%sfunc" and "/opt/brother/Printers/%s/inf/br%src".
# Whereby, %s is printf(3) string substitution for stdin's arg0 (the command's own filename) from the 10th char forwards, as a runtime dependency.
# e.g. Say the filename is "0123456789ABCDE", the runtime will be looking for /opt/brother/Printers/ABCDE/inf/brABCDEfunc.
# Presumably, the binary was designed to be deployed under the filename "printconf_mfcj6510dw", whereby it will search for "/opt/brother/Printers/mfcj6510dw/inf/brmfcj6510dwfunc".
# For NixOS, we want to change the string to the store path of brmfcj6510dwfunc and brmfcj6510dwrc but we're faced with two complications:
# 1. Too little room to specify the nix store path. We can't even take advantage of %s by renaming the file to the store path hash since the variable is too short and can't contain the whole hash.
# 2. The binary needs the directory it's running from to be r/w.
# What:
# As such, we strip the path and substitution altogether, leaving only "brmfcj6510dwfunc" and "brmfcj6510dwrc", while filling the leftovers with nulls.
# Fully null terminating the cstrings is necessary to keep the array the same size and preventing overflows.
# We then use a shell script to link and execute the binary, func and rc files in a temporary directory.
# How:
# In the package, we dump the raw binary as a string of search-able hex values using hexdump. We execute the substitution with sed. We then convert the hex values back to binary form using xxd.
# We also write a shell script that invoked "mktemp -d" to produce a r/w temporary directory and link what we need in the temporary directory.
# Result:
# The user can run brprintconf_mfcj6510dw in the shell.

stdenv.mkDerivation rec {
  pname = "mfcj6510dwlpr";
  version = "3.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006614/mfcj6510dwlpr-${version}.i386.deb";
    sha256 = "1ccvx393pqavsgzd8igrzlin5jrsf01d3acyvwqd1d0yz5jgqy6d";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    cups
    ghostscript
    dpkg
    a2ps
  ];

  dontUnpack = true;

  brprintconf_mfcj6510dw_script = ''
    #!${runtimeShell}
    cd $(mktemp -d)
    ln -s @out@/usr/bin/brprintconf_mfcj6510dw_patched brprintconf_mfcj6510dw_patched
    ln -s @out@/opt/brother/Printers/mfcj6510dw/inf/brmfcj6510dwfunc brmfcj6510dwfunc
    ln -s @out@/opt/brother/Printers/mfcj6510dw/inf/brmfcj6510dwrc brmfcj6510dwrc
    ./brprintconf_mfcj6510dw_patched "$@"
  '';

  installPhase = ''
    dpkg-deb -x $src $out
    substituteInPlace $out/opt/brother/Printers/mfcj6510dw/lpd/filtermfcj6510dw \
      --replace /opt "$out/opt"
    substituteInPlace $out/opt/brother/Printers/mfcj6510dw/lpd/psconvertij2 \
      --replace "GHOST_SCRIPT=`which gs`" "GHOST_SCRIPT=${ghostscript}/bin/gs"
    substituteInPlace $out/opt/brother/Printers/mfcj6510dw/inf/setupPrintcapij \
      --replace "/opt/brother/Printers" "$out/opt/brother/Printers" \
      --replace "printcap.local" "printcap"

    patchelf --set-interpreter ${pkgsi686Linux.stdenv.cc.libc.out}/lib/ld-linux.so.2 \
      --set-rpath $out/opt/brother/Printers/mfcj6510dw/inf:$out/opt/brother/Printers/mfcj6510dw/lpd \
      $out/opt/brother/Printers/mfcj6510dw/lpd/brmfcj6510dwfilter
    patchelf --set-interpreter ${pkgsi686Linux.stdenv.cc.libc.out}/lib/ld-linux.so.2 $out/usr/bin/brprintconf_mfcj6510dw

    #stripping the hardcoded path.
    ${util-linux}/bin/hexdump -ve '1/1 "%.2X"' $out/usr/bin/brprintconf_mfcj6510dw | \
    sed 's.2F6F70742F62726F746865722F5072696E746572732F25732F696E662F6272257366756E63.62726d66636a36353130647766756e63000000000000000000000000000000000000000000.' | \
    sed 's.2F6F70742F62726F746865722F5072696E746572732F25732F696E662F627225737263.62726D66636A3635313064777263000000000000000000000000000000000000000000.' | \
    ${xxd}/bin/xxd -r -p > $out/usr/bin/brprintconf_mfcj6510dw_patched
    chmod +x $out/usr/bin/brprintconf_mfcj6510dw_patched
    #executing from current dir. segfaults if it's not r\w.
    mkdir -p $out/bin
    echo -n "$brprintconf_mfcj6510dw_script" > $out/bin/brprintconf_mfcj6510dw
    chmod +x $out/bin/brprintconf_mfcj6510dw
    substituteInPlace $out/bin/brprintconf_mfcj6510dw --replace @out@ $out

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/mfcj6510dw/lpd/filtermfcj6510dw $out/lib/cups/filter/brother_lpdwrapper_mfcj6510dw

    wrapProgram $out/opt/brother/Printers/mfcj6510dw/lpd/psconvertij2 \
      --prefix PATH ":" ${
        lib.makeBinPath [
          coreutils
          gnused
          gawk
        ]
      }
    wrapProgram $out/opt/brother/Printers/mfcj6510dw/lpd/filtermfcj6510dw \
      --prefix PATH ":" ${
        lib.makeBinPath [
          coreutils
          gnused
          file
          ghostscript
          a2ps
        ]
      }
  '';

  meta = with lib; {
    description = "Brother MFC-J6510DW LPR driver";
    downloadPage = "http://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj6510dw_all&os=128";
    homepage = "http://www.brother.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = with licenses; unfree;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; linux;
  };
}
