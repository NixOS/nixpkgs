{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "sdparm-1.03";

  src = fetchurl {
    url = http://sg.danny.cz/sg/p/sdparm-1.03.tgz;
    sha256 = "067bdhq2qc7h7ykf1yv86s9x12zscpqnsdlnr636a0nv0di2wymq";
  };

  meta = {
    homepage = http://sg.danny.cz/sg/sdparm.html;
    description = "A utility to access SCSI device parameters";
    license = "free";
  };
}
