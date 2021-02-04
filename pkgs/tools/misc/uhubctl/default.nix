{ lib, stdenv
, fetchFromGitHub
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "uhubctl";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "mvp";
    repo = "uhubctl";
    rev = "refs/tags/v${version}";
    sha256 = "1wxsiygw6gwv1h90yassnxylkyi2dfz7y59qkmb7rs8a8javj7nv";
  };

  buildInputs = [ libusb1 ];

  installFlags = [ "prefix=${placeholder "out"}" ];
  meta = with lib; {
    homepage = "https://github.com/mvp/uhubctl";
    description = "Utility to control USB power per-port on smart USB hubs";
    license = licenses.gpl2;
    maintainers = with maintainers; [ prusnak ];
    platforms = with platforms; linux ++ darwin;
  };
}
