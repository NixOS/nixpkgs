{ stdenv, libusb1, fetchgit}:


let
  rev = "85ee5eeaca59a1c92659c3f49b148b0447d78f16";
in

stdenv.mkDerivation {
  name = "alienfx-1.0.0";
  src = fetchgit {
    inherit rev;
    url = https://github.com/tibz/alienfx.git;

    sha256 = "47501a3b4e08d39edee4cd829ae24259a7e740b9798db76b846fa872989f8fb1";
  };

  patchPhase = ''
    substituteInPlace Makefile --replace /usr/ $out/
    substituteInPlace Makefile --replace "install -o root -g root" "install"
  '';
 
  buildInputs = [ libusb1 ];
  makeFlags = "build";
  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
  '';
  installTargets = "install";
  postInstall = ''cp alienfx.1 $out/man/man1'';
  
  meta = {
    description = "Controls AlienFX lighting";
    homepage = "https://github.com/tibz/alienfx";
    maintainers = [stdenv.lib.maintainers.tomberek];
    platforms = stdenv.lib.platforms.linux;
  };
}

