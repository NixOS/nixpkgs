{ stdenv, lib, fetchFromGitHub, makeWrapper, curl, openssl, socat, iproute2, unixtools, dnsutils }:
stdenv.mkDerivation rec {
  pname = "acme.sh";
  version = "2.8.8";

  src = fetchFromGitHub {
    owner = "Neilpang";
    repo = "acme.sh";
    rev = version;
    sha256 = "1iqwzqgg26vsg7lwmgmga9y3ap9q8r5xyx799bj8kawnr8n6s4jd";
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
    maintainers = [ maintainers.yorickvp ];
  };
}
