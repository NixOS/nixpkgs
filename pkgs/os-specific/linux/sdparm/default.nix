{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "sdparm-1.08";

  src = fetchurl {
    url = http://sg.danny.cz/sg/p/sdparm-1.08.tgz;
    sha256 = "0msy8anggdand1yr50vg2azcfgks7sbfpnqk7xzw9adi2jj7hsrp";
  };

  meta = {
    homepage = http://sg.danny.cz/sg/sdparm.html;
    description = "A utility to access SCSI device parameters";
    license = "free";
  };
}
