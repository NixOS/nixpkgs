{ stdenv, fetchFromGitHub, help2man }:

stdenv.mkDerivation rec {
  version = "1.1.2";
  name = "light-${version}";
  src = fetchFromGitHub {
    owner = "haikarainen";
    repo = "light";
    rev = version;
    sha256 = "0c934gxav9cgdf94li6dp0rfqmpday9d33vdn9xb2mfp4war9n4w";
  };

  buildInputs = [ help2man ];

  installPhase = "mkdir -p $out/bin; cp light $out/bin/";

  preFixup = "make man; mkdir -p $out/man/man1; mv light.1.gz $out/man/man1";

  meta = {
    description = "GNU/Linux application to control backlights";
    homepage = https://haikarainen.github.io/light/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    platforms = stdenv.lib.platforms.linux;
  };
}
