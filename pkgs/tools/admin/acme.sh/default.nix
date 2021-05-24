{ stdenv, lib, fetchFromGitHub, makeWrapper, curl, openssl, socat, iproute2, unixtools, dnsutils }:
stdenv.mkDerivation rec {
  pname = "acme.sh";
  version = "2.8.9";

  src = fetchFromGitHub {
    owner = "Neilpang";
    repo = "acme.sh";
    rev = version;
    sha256 = "sha256-xiLAvxly4WbMb6DAXPsXJgQqVmTlX9cbqFECJQ+r0Jk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out $out/bin $out/libexec
    cp -R $src/* $_
    makeWrapper $out/libexec/acme.sh $out/bin/acme.sh \
      --prefix PATH : "${
        lib.makeBinPath [
          socat
          openssl
          curl
          dnsutils
          (if stdenv.isLinux then iproute2 else unixtools.netstat)
        ]
      }"
  '';

  meta = with lib; {
    description = "A pure Unix shell script implementing ACME client protocol";
    homepage = "https://acme.sh/";
    license = licenses.gpl3;
    maintainers = teams.serokell.members;
  };
}
