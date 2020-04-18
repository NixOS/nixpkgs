{ stdenv, fetchFromGitHub, mkDerivation, cmake, protobuf
, qtbase, qtmultimedia, qttools, qtwebsockets, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "cockatrice";
  version = "2020-03-20-Release-2.7.4";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    rev = "${version}";
    sha256 = "1d229gswfcqxch19wb744d9h897qwzf2y9imwrbcwnlhpbr1j62k";
  };

  buildInputs = [
    cmake qtbase qtmultimedia protobuf qttools qtwebsockets
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  meta = {
    homepage = "https://github.com/Cockatrice/Cockatrice";
    description = "A cross-platform virtual tabletop for multiplayer card games";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ evanjs ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
