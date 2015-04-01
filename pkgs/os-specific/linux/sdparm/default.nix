{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "sdparm-1.09";

  src = fetchurl {
    url = http://sg.danny.cz/sg/p/sdparm-1.09.tar.xz;
    sha256 = "0jakqyjwi72zqjzss04bally0xl0lc4710mx8da08vpmir1hfphg";
  };

  meta = with stdenv.lib; {
    homepage = http://sg.danny.cz/sg/sdparm.html;
    description = "A utility to access SCSI device parameters";
    license = with licenses; bsd3;
    maintainers = with maintainers; [ nckx ];
  };
}
