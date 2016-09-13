{ stdenv, lib, fetchurl, rpmextract, unzip }:

stdenv.mkDerivation rec {
  name = "dell-2155cdn-${version}";
  version = "1.0-1";

  src = fetchurl {
    url = "http://downloads.dell.com/printer/06_2155_Driver_Linux.zip";
    sha256 = "1m1f1m34xiz39i33gdsgxyb7idgp0jj6mp48761v9hy8z3irza3a";
  };

  buildCommand = ''
    dir=$out/share/ppd/Dell
    mkdir -p $dir
    d=$(mktemp -d)

    cd $d
    ${unzip}/bin/unzip $src
    ${rpmextract}/bin/rpmextract Linux/Dell-2155-Color-MFP-${version}.i686.rpm
    mv ./usr/share/cups/model/Dell/Dell_*.ppd.gz $dir
  '';

  meta = with lib; {
    description = "PPDs for the Dell 2155cn and 2155cdn printers.";
    homepage = https://www.dell.com;
    # I don't know yet what the license is.
    license = licenses.unfree;
    platforms = platforms.unix;
    maintainers = with maintainers; [ peterhoeg ];
    downloadPage = http://www.dell.com/support/home/ed/en/eddhs1/product-support/product/dell-2155cn-cdn/drivers;
  };
}
