{ lib, cabextract, fetchFromGitHub, readline, stdenv_32bit }:

# stdenv_32bit is needed because the program depends upon 32-bit libraries and does not have
# support for 64-bit yet: it requires libc6-dev:i386, libreadline-dev:i386.

stdenv_32bit.mkDerivation rec {
  pname = "loadlibrary";
  version = "20170525-${lib.strings.substring 0 7 rev}";
  rev = "721b084c088d779075405b7f20c77c2578e2a961";
  src = fetchFromGitHub {
    inherit rev;
    owner = "taviso";
    repo = "loadlibrary";
    sha256 = "01hb7wzfh1s5b8cvmrmr1gqknpq5zpzj9prq3wrpsgg129jpsjkb";
  };

  buildInputs = [ cabextract readline ];

  installPhase = ''
    mkdir -p $out/bin/
    cp mpclient $out/bin/
  '';

  meta = with lib; {
    homepage = "https://github.com/taviso/loadlibrary";
    description = "Porting Windows Dynamic Link Libraries to Linux";
    platforms = platforms.linux;
    maintainers = [ maintainers.eleanor ];
    license = licenses.gpl2;
    mainProgram = "mpclient";
  };
}
