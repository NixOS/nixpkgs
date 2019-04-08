{ stdenv, lib, fetchFromGitHub, makeWrapper, curl, openssl, socat, iproute }:
stdenv.mkDerivation rec {
  name = "acme.sh-${version}";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "Neilpang";
    repo = "acme.sh";
    rev = version;
    sha256 = "1h22bmx065v0lhwkr4zykybfl6ppjr2wibgwy2wnihy30g28zq7v";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out $out/bin $out/libexec
    cp -R $src/* $_
    makeWrapper $out/libexec/acme.sh $out/bin/acme.sh \
      --prefix PATH : "${lib.makeBinPath [ socat openssl curl iproute ]}"
  '';

  meta = with stdenv.lib; {
    description = "A pure Unix shell script implementing ACME client protocol";
    homepage = https://acme.sh/;
    license = licenses.gpl3;
    maintainers = [ maintainers.yorickvp ];
  };
}
