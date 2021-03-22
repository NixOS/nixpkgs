{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kloak";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "vmonaco";
    repo = "kloak";
    rev = "v${version}";
    sha256 = "1jkds8i3x419fcrgdskzbwypgqbyqcypg6kris600l1y7z6hapj9";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ./kloak ./eventcap $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Keystroke-level online anonymization kernel: obfuscates typing behavior at the device level";
    longDescription = "Note that this requires loading the 'uinput' kernel module.";
    homepage = "https://github.com/vmonaco/kloak";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ryneeverett ];
    platforms = platforms.linux;
  };
}
