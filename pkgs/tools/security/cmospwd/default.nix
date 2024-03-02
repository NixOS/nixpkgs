{ lib
, fetchurl
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmospwd";
  version = "5.1";

  src = fetchurl {
    url = "https://www.cgsecurity.org/cmospwd-${finalAttrs.version}.tar.bz2";
    hash = "sha256-8pbSl5eUsKa3JrgK/JLk0FnGXcJhKksJN3wWiDPYYvQ=";
  };

  makeFlags = [ "CC:=$(CC)" ];

  preConfigure = ''
    cd src

    # It already contains compiled executable (that doesn't work), so make
    # will refuse to build if it's still there
    rm cmospwd
  '';

  # There is no install make target
  installPhase = ''
    runHook preInstall
    install -Dm0755 cmospwd -t "$out/bin"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Decrypt password stored in cmos used to access BIOS SETUP";
    homepage = "https://www.cgsecurity.org/wiki/CmosPwd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ t4ccer ];
    platforms = [ "x86_64-linux" ];
  };
})
