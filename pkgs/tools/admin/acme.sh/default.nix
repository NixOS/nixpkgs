{ stdenv, lib, fetchFromGitHub, makeWrapper, curl, openssl, socat, iproute, unixtools }:
stdenv.mkDerivation rec {
  pname = "acme.sh";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "Neilpang";
    repo = "acme.sh";
    rev = version;
    sha256 = "0yxhfdb0jz0wn10ka6c79qvcx07656vsaxmjls8qgcfgc472ymhs";
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
