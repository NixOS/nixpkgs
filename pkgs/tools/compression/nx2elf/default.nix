{ lib, stdenv, fetchFromGitHub, lz4 }:

stdenv.mkDerivation rec {
  pname = "nx2elf";
  version = "unstable-2020-05-26";

  src = fetchFromGitHub {
    owner = "shuffle2";
    repo = "nx2elf";
    rev = "7212e82a77b84fcc18ef2d050970350dbf63649b";
    sha256 = "1j4k5s86c6ixa3wdqh4cfm31fxabwn6jcjc6pippx8mii98ac806";
  };

  buildInputs = [ lz4 ];

  postPatch = ''
    # This project does not comply with C++14 standards, and compilation on that fails.
    # This does however succesfully compile with the gnu++20 standard.
    substituteInPlace Makefile --replace "c++14" "gnu++20"

    # pkg-config is not supported, so we'll manually use a non-ancient version of lz4
    cp ${lz4.src}/lib/lz4.{h,c} .
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -D nx2elf $out/bin/nx2elf
  '';

  meta = with lib; {
    homepage = "https://github.com/shuffle2/nx2elf";
    description = "Convert Nintendo Switch executable files to ELFs";
    license = licenses.unfree; # No license specified upstream
    platforms = [ "x86_64-linux" ]; # Should work on Darwin as well, but this is untested. aarch64-linux fails.
    maintainers = [ maintainers.ivar ];
  };
}
