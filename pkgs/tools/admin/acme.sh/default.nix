{ stdenv, lib, fetchFromGitHub, makeWrapper, curl, openssl, socat, iproute2,
  unixtools, dnsutils, coreutils, gnugrep, gnused }:
stdenv.mkDerivation rec {
  pname = "acme.sh";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "Neilpang";
    repo = "acme.sh";
    rev = version;
    sha256 = "sha256-BSKqfj8idpE4OV8/EJkCFo5i1vq/aEde/moqJcwuDvk=";
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
