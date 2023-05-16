<<<<<<< HEAD
{ lib, stdenv, fetchurl, zlib, installShellFiles }:
=======
{ lib, stdenv, fetchurl, zlib }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "pngcheck";
  version = "3.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/png-mng/pngcheck-${version}.tar.gz";
    sha256 = "sha256-DX4mLyQRb93yhHqM61yS2fXybvtC6f/2PsK7dnYTHKc=";
  };

  hardeningDisable = [ "format" ];

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace $makefile \
      --replace "gcc" "$CC"
=======
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.unx --replace "gcc" "clang"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  makefile = "Makefile.unx";
  makeFlags = [ "ZPATH=${zlib.static}/lib" ];

<<<<<<< HEAD
  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin/ pngcheck
    installManPage $pname.1
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://pmt.sourceforge.net/pngcrush";
=======
  buildInputs = [ zlib ];

  installPhase = ''
    mkdir -p $out/bin/
    cp pngcheck $out/bin/pngcheck
  '';

  meta = with lib; {
    homepage = "http://pmt.sourceforge.net/pngcrush";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Verifies the integrity of PNG, JNG and MNG files";
    license = licenses.free;
    platforms = platforms.unix;
    maintainers = with maintainers; [ starcraft66 ];
  };
}
