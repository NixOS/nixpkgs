{ lib, stdenv
, fetchgit
, autoreconfHook
, gd
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "ptouch-print";
  version = "1.4.3";

  src = fetchgit {
    url = "https://mockmoon-cybernetics.ch/cgi/cgit/linux/ptouch-print.git";
    rev = "v${version}";
    sha256 = "0i57asg2hj1nfwy5lcb0vhrpvb9dqfhf81vh4i929h1kiqhlw2hx";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    gd
    libusb1
  ];

  meta = with lib; {
    description = "Command line tool to print labels on Brother P-Touch printers on Linux";
    license = licenses.gpl3Plus;
    homepage = "https://mockmoon-cybernetics.ch/computer/p-touch2430pc/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
    mainProgram = "ptouch-print";
  };
}
