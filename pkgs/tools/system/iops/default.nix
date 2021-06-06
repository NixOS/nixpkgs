{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "iops";
  version = "0.1";

  src = fetchurl {
    url = "https://www.vanheusden.com/iops/${pname}-${version}.tgz";
    sha256 = "1knih6dwwiicycp5ml09bj3k8j7air9bng070sfnxwfv786y90bz";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp iops $out/bin
  '';

  meta = with lib; {
    description = "Measure I/O operations per second of a storage device";
    longDescription = ''
      Iops lets you measure how many I/O operations per second a storage device can perform.
      Usefull for determing e.g. the best RAID-setting of your storage device.
    '';
    homepage = "http://www.vanheusden.com/iops/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.linux; # build problems on Darwin
  };
}

