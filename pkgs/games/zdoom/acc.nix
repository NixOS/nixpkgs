{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "acc-${version}";
  version = "1.56";

  src = fetchFromGitHub {
    owner = "rheit";
    repo = "acc";
    rev = version;
    sha256 = "1vkb7cdj5pl0hr0jhl9laiyrfwng63ifaapqaxg4l0py06sd67p1";
  };

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/acc/scripts
    install -m755 acc $out/bin/acc
    install -m644 *.acs $out/share/acc/scripts
  '';

  meta = with stdenv.lib; {
    description = "Compiler for Action Code Script (ACS) for ZDoom/Hexen/Heretic-based games";
    homepage = https://zdoom.org/wiki/ACC;
    license = licenses.unfree;
    maintainers = with maintainers; [ertes];
  };
}
