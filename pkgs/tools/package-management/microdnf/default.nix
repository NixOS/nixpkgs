{ lib, stdenv, fetchFromGitHub, cmake, gettext, libdnf, pkg-config, glib, libpeas, libsmartcols, help2man }:

stdenv.mkDerivation rec {
  pname = "microdnf";
<<<<<<< HEAD
  version = "3.10.0";
=======
  version = "3.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-R7jOeH6pw/THLXxLezp2AmE8lUBagKMRJ0XfXgdLi2E=";
=======
    sha256 = "sha256-/6yMHjB9HNEEQuAc8zEvmjjl6wur0jByS1hLz39+rHI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config cmake gettext help2man ];
  buildInputs = [ libdnf glib libpeas libsmartcols ];

  meta = with lib; {
    description = "Lightweight implementation of dnf in C";
    homepage = "https://github.com/rpm-software-management/microdnf";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ rb2k ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
