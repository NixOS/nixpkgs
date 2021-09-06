{ lib, stdenv, fetchurl, cups, dpkg, gnused, makeWrapper, ghostscript, file
, a2ps, coreutils, perl, gnugrep, which, gawk
}:

let
version = "1.1.2-1";
lprdeb = fetchurl {
url = "https://download.brother.com/welcome/dlf100441/dcp9020cdwlpr-${version}.i386.deb";
sha256 = "1z6nma489s0a0b0a8wyg38yxanz4k99dg29fyjs4jlprsvmwk56y";
};

cupsdeb = fetchurl {
url = "https://download.brother.com/welcome/dlf100443/dcp9020cdwcupswrapper-${version}.i386.deb";
sha256 = "04yqm1qv9p4hgp1p6mqq4siygl4056s6flv6kqln8mvmcr8zaq1s";
};

model = "dcp9020cdw";

in
stdenv.mkDerivation {
name = "cups-brother-${model}";

nativeBuildInputs = [ makeWrapper ];
buildInputs = [ cups ghostscript dpkg a2ps gawk ];

dontUnpack = true;

installPhase = ''
mkdir -p $out
dpkg-deb -x ${cupsdeb} $out
dpkg-deb -x ${lprdeb} $out

substituteInPlace $out/opt/brother/Printers/${model}/lpd/filter${model} \
--replace /opt "$out/opt" \
--replace /usr/bin/perl ${perl}/bin/perl \
--replace "BR_CFG_PATH =~" "BR_CFG_PATH = \"$out/opt/brother/Printers/${model}/\"; #" \
--replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/${model}/\"; #" \
--replace "PRINTER =~" "PRINTER = \"DCP9020CDW\"; #"

patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
$out/opt/brother/Printers/${model}/lpd/br${model}filter
#patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
#  $out/opt/brother/Printers/${model}/cupswrapper/brcupsconfpt1

for f in \
$out/opt/brother/Printers/${model}/cupswrapper/cupswrapper${model} \
; do
wrapProgram $f \
--prefix PATH : ${lib.makeBinPath [
coreutils ghostscript gnugrep gnused
]}
done

mkdir -p $out/lib/cups/filter/
ln -s $out/opt/brother/Printers/${model}/lpd/filter${model} $out/lib/cups/filter/brother_lpdwrapper_${model}

mkdir -p $out/share/cups/model
ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model/

wrapProgram $out/opt/brother/Printers/${model}/lpd/filter${model} \
--prefix PATH ":" ${ lib.makeBinPath [ gawk ghostscript a2ps file gnused gnugrep coreutils which ] }
'';

meta = with lib; {
homepage = "http://www.brother.com/";
description = "Brother ${model} printer driver";
license = licenses.unfree;
platforms = platforms.linux;
downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_eu&os=128";
maintainers = [ ];
};
}
