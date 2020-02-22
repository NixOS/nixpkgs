{ stdenv, fetchFromGitHub, mkDerivation, cmake, protobuf
, qtbase, qtmultimedia, qttools, qtwebsockets, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "cockatrice";
  version = "2019-08-31-Release-2.7.2";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    rev = "${version}";
    sha256 = "17nfz4z6zfkiwcrq1rpm8bc7zh4gvcmb3fis9gdjjbji20dvcfxp";
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
