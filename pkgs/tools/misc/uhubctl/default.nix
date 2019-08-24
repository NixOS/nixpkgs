{ stdenv
, fetchFromGitHub
, libusb
}:

stdenv.mkDerivation rec {
  pname = "uhubctl";
  version = "unstable-2019-07-31";

  src = fetchFromGitHub {
    owner = "mvp";
    repo = "uhubctl";
    rev = "1961aa02e9924a54a6219d16c61a0beb0d626e46";
    sha256 = "15mvqp1xh079nqp0mynh3l1wmw4maa320pn4jr8bz7nh3knmk0n1";
  };

  buildInputs = [ libusb ];

  installFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mvp/uhubctl";
    description = "Utility to control USB power per-port on smart USB hubs";
    license = licenses.gpl2;
    maintainers = with maintainers; [ prusnak ];
    platforms = with platforms; linux ++ darwin;
  };
}
