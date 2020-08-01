{ stdenv, fetchurl, pkgsi686Linux, dpkg, makeWrapper, coreutils, gnused, gawk, file, cups, utillinux, xxd, runtimeShell
, ghostscript, a2ps }:

# Why:
# The executable "brprintconf_mfcj835dw" binary is looking for "/opt/brother/Printers/%s/inf/br%sfunc" and "/opt/brother/Printers/%s/inf/br%src".
# Whereby, %s is printf(3) string substitution for stdin's arg0 (the command's own filename) from the 10th char forwards, as a runtime dependency.
# e.g. Say the filename is "0123456789ABCDE", the runtime will be looking for /opt/brother/Printers/ABCDE/inf/brABCDEfunc.
# Presumably, the binary was designed to be deployed under the filename "printconf_mfcj835dw", whereby it will search for "/opt/brother/Printers/mfcj835dw/inf/brmfcj835dwfunc".
# For NixOS, we want to change the string to the store path of brmfcj835dwfunc and brmfcj835dwrc but we're faced with two complications:
# 1. Too little room to specify the nix store path. We can't even take advantage of %s by renaming the file to the store path hash since the variable is too short and can't contain the whole hash.
# 2. The binary needs the directory it's running from to be r/w.
# What:
# As such, we strip the path and substitution altogether, leaving only "brmfcj835dwfunc" and "brmfcj835dwrc", while filling the leftovers with nulls.
# Fully null terminating the cstrings is necessary to keep the array the same size and preventing overflows.
# We then use a shell script to link and execute the binary, func and rc files in a temporary directory.
# How:
# In the package, we dump the raw binary as a string of search-able hex values using hexdump. We execute the substitution with sed. We then convert the hex values back to binary form using xxd.
# We also write a shell script that invoked "mktemp -d" to produce a r/w temporary directory and link what we need in the temporary directory.
# Result:
# The user can run brprintconf_mfcj835dw in the shell.

stdenv.mkDerivation rec {
  pname = "mfcj835dwlpr";
  version = "3.0.1-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006630/mfcj835dwlpr-${version}.i386.deb";
    sha256 = "1p48blsjihb90wpcl4wag8mggc9r5098cb7g28lkmhaqa0ixgln6";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cups ghostscript dpkg a2ps ];

  dontUnpack = true;

  brprintconf_mfcj835dw_script = ''
    #!${runtimeShell}
    cd $(mktemp -d)
    ln -s @out@/usr/bin/brprintconf_mfcj835dw_patched brprintconf_mfcj835dw_patched
    ln -s @out@/opt/brother/Printers/mfcj835dw/inf/brmfcj835dwfunc brmfcj835dwfunc
    ln -s @out@/opt/brother/Printers/mfcj835dw/inf/brmfcj835dwrc brmfcj835dwrc
    ./brprintconf_mfcj835dw_patched "$@"
  '';

  installPhase = ''
    dpkg-deb -x $src $out
    substituteInPlace $out/opt/brother/Printers/mfcj835dw/lpd/filtermfcj835dw \
      --replace /opt "$out/opt"
    substituteInPlace $out/opt/brother/Printers/mfcj835dw/lpd/psconvertij2 \
      --replace "GHOST_SCRIPT=`which gs`" "GHOST_SCRIPT=${ghostscript}/bin/gs"
    substituteInPlace $out/opt/brother/Printers/mfcj835dw/inf/setupPrintcapij \
      --replace "/opt/brother/Printers" "$out/opt/brother/Printers" \
      --replace "printcap.local" "printcap"

    patchelf --set-interpreter ${pkgsi686Linux.stdenv.cc.libc.out}/lib/ld-linux.so.2 \
      --set-rpath $out/opt/brother/Printers/mfcj835dw/inf:$out/opt/brother/Printers/mfcj835dw/lpd \
      $out/opt/brother/Printers/mfcj835dw/lpd/brmfcj835dwfilter
    patchelf --set-interpreter ${pkgsi686Linux.stdenv.cc.libc.out}/lib/ld-linux.so.2 $out/usr/bin/brprintconf_mfcj835dw

    #stripping the hardcoded path.
    ${utillinux}/bin/hexdump -ve '1/1 "%.2X"' $out/usr/bin/brprintconf_mfcj835dw | \
    sed 's.2F6F70742F62726F746865722F5072696E746572732F25732F696E662F6272257366756E63.62726d66636a36353130647766756e63000000000000000000000000000000000000000000.' | \
    sed 's.2F6F70742F62726F746865722F5072696E746572732F25732F696E662F627225737263.62726D66636A3635313064777263000000000000000000000000000000000000000000.' | \
    ${xxd}/bin/xxd -r -p > $out/usr/bin/brprintconf_mfcj835dw_patched
    chmod +x $out/usr/bin/brprintconf_mfcj835dw_patched
    #executing from current dir. segfaults if it's not r\w.
    mkdir -p $out/bin
    echo -n "$brprintconf_mfcj835dw_script" > $out/bin/brprintconf_mfcj835dw
    chmod +x $out/bin/brprintconf_mfcj835dw
    substituteInPlace $out/bin/brprintconf_mfcj835dw --replace @out@ $out

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/mfcj835dw/lpd/filtermfcj835dw $out/lib/cups/filter/brother_lpdwrapper_mfcj835dw

    wrapProgram $out/opt/brother/Printers/mfcj835dw/lpd/psconvertij2 \
      --prefix PATH ":" ${ stdenv.lib.makeBinPath [ coreutils gnused gawk ] }
    wrapProgram $out/opt/brother/Printers/mfcj835dw/lpd/filtermfcj835dw \
      --prefix PATH ":" ${ stdenv.lib.makeBinPath [ coreutils gnused file ghostscript a2ps ] }
    '';

  meta = with stdenv.lib; {
    description  = "Brother MFC-J835DW LPR driver";
    downloadPage = https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj835dw_us&os=128;
    homepage     = http://www.brother.com/;
    license      = with licenses; unfree;
    maintainers  = with maintainers; [ zandroidius ];
    platforms    = with platforms; linux;
  };
}
