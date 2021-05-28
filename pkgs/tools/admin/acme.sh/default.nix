{ stdenv, lib, fetchFromGitHub, makeWrapper, curl, openssl, socat, iproute, unixtools, dnsutils }:
stdenv.mkDerivation rec {
  pname = "acme.sh";
  version = "2.8.7";

  src = fetchFromGitHub {
    owner = "Neilpang";
    repo = "acme.sh";
    rev = version;
    sha256 = "0bwzrrm07v2lpsja0r0z7nj3jrf814w57mmk8lbdk9dsb3i07x4w";
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
          (if stdenv.isLinux then iproute else unixtools.netstat)
        ]
      }"
  '';

  meta = with stdenv.lib; {
    description = "A pure Unix shell script implementing ACME client protocol";
    homepage = "https://acme.sh/";
    license = licenses.gpl3;
    maintainers = [ maintainers.yorickvp ];
  };
}
