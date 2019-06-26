{ stdenv, makeWrapper, fetchFromGitHub, libnitrokey, pkgconfig }:

stdenv.mkDerivation rec {
  name = "nitro_luks-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mogorman";
    repo = "nitroluks";
    rev = "${version}";
    sha256 ="0s5kgxadyv116iacbagnsp60mnizdavfysm5agqbms0nm7rmzlw9";
  };

  buildInputs = [
    libnitrokey
  ];

  nativeBuildInputs = [
    pkgconfig
    makeWrapper
  ];

  installPhase = ''
    install -D -m 0755 nitro_luks $out/bin/nitro_luks
  '';

  meta = with stdenv.lib; {
    description      = "Use nitrokey to unlock your luks drive on boot";
    homepage         = https://github.com/mogorman/nitroluks;
    license          = licenses.gpl3;
    maintainers      = with maintainers; [ mog ];
  };
}
