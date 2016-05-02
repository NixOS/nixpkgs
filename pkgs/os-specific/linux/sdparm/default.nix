{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "sdparm-${version}";
  version = "1.10";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/${name}.tar.xz";
    sha256 = "1jjq3lzgfy4r76rc26q02lv4wm5cb4dx5nh913h489zjrr4f3jbx";
  };

  meta = with stdenv.lib; {
    homepage = http://sg.danny.cz/sg/sdparm.html;
    description = "A utility to access SCSI device parameters";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nckx ];
  };
}
