{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libwhich";
  version = "2019-03-20";

  src = fetchFromGitHub {
    owner = "vtjnash";
    repo = pname;
    rev = "b348872107c77cba50b60475aa8ce2ddba86aac0";
    sha256 = "0fd8hsdc9b9v83j89mxvisgrz77q9rlxnbzd6j63wq66h95r02r9";
  };

  installPhase = ''
    install -Dm755 -t $out/bin libwhich
  '';

  meta = with stdenv.lib; {
    description = "Like `which`, for dynamic libraries";
    homepage = https://github.com/vtjnash/libwhich;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
