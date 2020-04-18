{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libwhich";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "vtjnash";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s0pqai61jszmi495k621rdlf288ij67adkz72hwqqarqp54idhb";
  };

  installPhase = ''
    install -Dm755 -t $out/bin libwhich
  '';

  meta = with stdenv.lib; {
    description = "Like `which`, for dynamic libraries";
    homepage = "https://github.com/vtjnash/libwhich";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
