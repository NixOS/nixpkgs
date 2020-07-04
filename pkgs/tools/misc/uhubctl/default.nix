{ stdenv
, fetchFromGitHub
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "uhubctl";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "mvp";
    repo = "uhubctl";
    rev = "refs/tags/v${version}";
    sha256 = "0pimhw2a2wfg7nh1ahsxmzkb0j6bbncwdqsvyp8l23zhs5kx7wm9";
  };

  buildInputs = [ libusb1 ];

  installFlags = [ "prefix=${placeholder "out"}" ];
  meta = with stdenv.lib; {
    homepage = "https://github.com/mvp/uhubctl";
    description = "Utility to control USB power per-port on smart USB hubs";
    license = licenses.gpl2;
    maintainers = with maintainers; [ prusnak ];
    platforms = with platforms; linux ++ darwin;
  };
}
