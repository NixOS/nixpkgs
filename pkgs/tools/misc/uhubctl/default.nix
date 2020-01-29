{ stdenv
, fetchFromGitHub
, libusb
}:

stdenv.mkDerivation rec {
  pname = "uhubctl";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "mvp";
    repo = "uhubctl";
    rev = "refs/tags/v${version}";
    sha256 = "1cgmwsf68g49k6q4jvz073bpjhg5p73kk1a4kbgkxmvx01gmbcmq";
  };

  buildInputs = [ libusb ];

  installFlags = [ "prefix=${placeholder "out"}" ];
  meta = with stdenv.lib; {
    homepage = "https://github.com/mvp/uhubctl";
    description = "Utility to control USB power per-port on smart USB hubs";
    license = licenses.gpl2;
    maintainers = with maintainers; [ prusnak ];
    platforms = with platforms; linux ++ darwin;
  };
}
