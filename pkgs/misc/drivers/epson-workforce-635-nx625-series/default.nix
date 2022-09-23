{
  autoreconfHook, cups, libjpeg, rpmextract,
  fetchurl, lib, stdenv
}:

let
  srcdirs = {
    filter = "epson-inkjet-printer-filter-1.0.0";
    driver = "epson-inkjet-printer-workforce-635-nx625-series-1.0.1";
  };
in stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-workforce-635-nx625-series";
  version = "1.0.1";

  src = fetchurl {
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download.ebz.epson.net/dsc/op/stable/SRPMS/${pname}-${version}-1lsb3.2.src.rpm"
      "https://web.archive.org/web/https://download.ebz.epson.net/dsc/op/stable/SRPMS/${pname}-${version}-1lsb3.2.src.rpm"
    ];
    sha256 = "19nb2h0y9rvv6rg7j262f8sqap9kjvz8kmisxnjg1w0v19zb9zf2";
  };
  sourceRoot = srcdirs.filter;

  nativeBuildInputs = [ autoreconfHook rpmextract ];
  buildInputs = [ cups libjpeg ];

  unpackPhase = ''
    rpmextract "$src"
    for i in ${lib.concatStringsSep " " (builtins.attrValues srcdirs)}; do
        tar xvf "$i".tar.gz
    done
  '';

  preConfigure = ''
    chmod u+x configure
  '';

  installPhase =
    let
      filterdir = "$out/cups/lib/filter";
      docdir  = "$out/share/doc";
      ppddir  = "$out/share/cups/model/${pname}";
      libdir =
        if stdenv.system == "x86_64-linux"    then "lib64"
        else if stdenv.system == "i686_linux" then "lib"
        else throw "other platforms than i686_linux and x86_64-linux are not yet supported";
    in ''
      mkdir -p "$out" "${docdir}" "${filterdir}" "${ppddir}"
      cp src/epson_inkjet_printer_filter "${filterdir}"

      cd ../${srcdirs.driver}
      for ppd in ppds/*; do
          substituteInPlace "$ppd" --replace '/opt/${pname}' "$out"
          gzip -c "$ppd" > "${ppddir}/''${ppd#*/}"
      done
      cp COPYING.EPSON README "${docdir}"
      cp -r resource watermark ${libdir} "$out"
    '';

  meta = {
    description = "Proprietary CUPS drivers for Epson inkjet printers";
    longDescription = ''
      This software is a filter program used with Common UNIX Printing
      System (CUPS) from the Linux. This can supply the high quality print
      with Seiko Epson Color Ink Jet Printers.

      This printer driver is supporting the following printers.

      WorkForce 60
      WorkForce 625
      WorkForce 630
      WorkForce 633
      WorkForce 635
      WorkForce T42WD
      Epson Stylus NX625
      Epson Stylus SX525WD
      Epson Stylus SX620FW
      Epson Stylus TX560WD
      Epson Stylus Office B42WD
      Epson Stylus Office BX525WD
      Epson Stylus Office BX625FWD
      Epson Stylus Office TX620FWD
      Epson ME OFFICE 82WD
      Epson ME OFFICE 85ND
      Epson ME OFFICE 900WD
      Epson ME OFFICE 960FWD

      License: LGPL and SEIKO EPSON CORPORATION SOFTWARE LICENSE AGREEMENT

      To use the driver adjust your configuration.nix file:
        services.printing = {
          enable = true;
          drivers = [ pkgs.${pname} ];
        };
    '';
    downloadPage = "https://download.ebz.epson.net/dsc/du/02/DriverDownloadInfo.do?LG2=EN&CN2=&DSCMI=16857&DSCCHK=4334d3487503d7f916ccf5d58071b05b7687294f";
    license = with lib.licenses; [ lgpl21 epson ];
    maintainers = [ lib.maintainers.jorsn ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
