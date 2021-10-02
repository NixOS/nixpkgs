{ stdenv, lib, fetchFromGitHub, makeWrapper, curl, openssl, socat, iproute2,
  unixtools, dnsutils, coreutils, gnugrep, gnused }:
stdenv.mkDerivation rec {
  pname = "acme.sh";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "Neilpang";
    repo = "acme.sh";
    rev = version;
    sha256 = "sha256-KWSDAHzvNl8Iao13OV/ExRoKqkc9nouWim+bAN1V+Jo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out $out/bin $out/libexec
    cp -R $src/* $_
    makeWrapper $out/libexec/acme.sh $out/bin/acme.sh \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
          socat
          openssl
          curl
          dnsutils
          (if stdenv.isLinux then iproute2 else unixtools.netstat)
        ]
      }"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A pure Unix shell script implementing ACME client protocol";
    homepage = "https://acme.sh/";
    license = licenses.gpl3;
    maintainers = teams.serokell.members;
  };
}
