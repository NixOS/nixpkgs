{ lib, stdenvNoCC, fetchFromGitHub, makeWrapper, fzf, gawk }:

stdenvNoCC.mkDerivation rec {
  pname = "sysz";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "joehillen";
    repo = pname;
    rev = version;
    sha256 = "HNwsYE1Cv90IDi3A5PmRv3uHANR3ya+VOGBQ3+zkBLM=";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 sysz $out/libexec/sysz
    makeWrapper $out/libexec/sysz $out/bin/sysz \
      --prefix PATH : ${lib.makeBinPath [ fzf gawk ]}
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/joehillen/sysz";
    description = "A fzf terminal UI for systemctl";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hleboulanger ];
    platforms = platforms.unix;
    changelog = "https://github.com/joehillen/sysz/blob/${version}/CHANGELOG.md";
  };
}
