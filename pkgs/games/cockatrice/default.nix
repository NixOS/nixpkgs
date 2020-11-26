{ stdenv, fetchFromGitHub, mkDerivation, cmake, protobuf
, qtbase, qtmultimedia, qttools, qtwebsockets, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "cockatrice";
  version = "2020-08-23-Release-2.7.5";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    rev = version;
    sha256 = "1yaxm7q0ja3rgx197hh8ynjc6ncc4hm0qdn9v7f0l4fbv0bdpv34";
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
