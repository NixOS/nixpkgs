{ lib, stdenv, fetchFromGitHub
, cmake, makeWrapper
, alsa-lib, fontconfig, mesa_glu, libXcursor, libXinerama, libXrandr, xorg
}:

stdenv.mkDerivation rec {
  pname = "bonzomatic";
  version = "2022-08-20";

  src = fetchFromGitHub {
    owner = "Gargaj";
    repo = pname;
    rev = version;
    sha256 = "sha256-AaUMefxQd00O+MAH4OLoyQIXZCRQQbt2ucgt7pVvN24=";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [
    alsa-lib fontconfig mesa_glu
    libXcursor libXinerama libXrandr xorg.xinput xorg.libXi xorg.libXext
  ];

  postFixup = ''
    wrapProgram $out/bin/bonzomatic --prefix LD_LIBRARY_PATH : "${alsa-lib}/lib"
  '';

  meta = with lib; {
    description = "Live shader coding tool and Shader Showdown workhorse";
    homepage = "https://github.com/gargaj/bonzomatic";
    license = licenses.unlicense;
    maintainers = [ maintainers.ilian ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
