{ stdenv, lib, fetchFromGitHub, makeWrapper, curl, openssl, socat, iproute, unixtools }:
stdenv.mkDerivation rec {
  name = "acme.sh-${version}";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "Neilpang";
    repo = "acme.sh";
    rev = version;
    sha256 = "07bq6axgq33djp87kkx7c5cv8n80gclvj247n9j514zqly6abdxy";
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
          (if stdenv.isLinux then iproute else unixtools.netstat)
        ]
      }"
  '';

  meta = with stdenv.lib; {
    description = "A pure Unix shell script implementing ACME client protocol";
    homepage = https://acme.sh/;
    license = licenses.gpl3;
    maintainers = [ maintainers.yorickvp ];
  };
}
