{ coreutils, dpkg, fetchurl, mfc9340cdwlpr, stdenv, perl, gnugrep, gnused, makeWrapper }:

stdenv.mkDerivation rec {
  name = "mfc9340cdwcupswrapper-${version}";
  version = "1.1.4-0";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf007029/${name}.i386.deb";
    sha256 = "0dlwpcmknqf4rndjjg3jh1141x536a71l3i2i8kpyvn7xs4bv8kv";
  };

  nativeBuildInputs = [ dpkg perl makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    dpkg-deb -x $src $out

    basedir=${mfc9340cdwlpr}/opt/brother/Printers/mfc9340cdw
    dir=$out/opt/brother/Printers/mfc9340cdw

    orig_filter="$dir/cupswrapper/cupswrappermfc9340cdw"
    dest_filter="$out/lib/cups/filter/brother_lpdwrapper_mfc9340cdw"

    substituteInPlace $orig_filter \
      --replace "/opt/brother/Printers/$``{printer_model}``/inf/" "${mfc9340cdwlpr}/opt/brother/Printers/mfc9340cdw/inf/" \
      --replace "/opt/brother/$``{device_model}``/$``{printer_model}``/lpd/" "${mfc9340cdwlpr}/opt/brother/Printers/mfc9340cdw/lpd/" \
      --replace "/opt/brother/$``{device_model}``/$``{printer_model}``/cupswrapper/" "$dir/cupswrapper/" \
      --replace "/opt/brother/$``{device_model}``/$``{printer_model}``/inf/" "$dir/inf/" \
      --replace "/var/tmp/" "/tmp/" \
      --replace "/usr/share/" "$out/share/" \
      --replace "/usr/lib/cups/filter" "$out/lib/cups/filter" \
      --replace "sleep 2s" "echo sleep 2s" \
      --replace "lpinfo -v" "true" \
      --replace "lpadmin -p" "echo lpadmin -p"

    chmod +x $orig_filter

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    bash $orig_filter
    test -x $dest_filter

    wrapProgram $dest_filter \
      --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils gnugrep gnused ]}
  '';

  meta = {
    description = "Brother MFC-9340CDW CUPS wrapper driver";
    homepage = http://www.brother.com/;
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
  };
}
