{ stdenv, fetchFromGitHub, libnetfilter_queue, libnfnetlink }:

stdenv.mkDerivation rec {
  name = "freebind-${version}";
  version = "2017-12-27";

  src = fetchFromGitHub {
    owner = "blechschmidt";
    repo = "freebind";
    rev = "9a13d6f9c12aeea4f6d3513ba2461d34f841f278";
    sha256 = "1iv2xiz9w8hbz684caw50fn4a9vc8ninfgaqafkh9sa8mzpfzcqr";
  };

  buildInputs = [ libnetfilter_queue libnfnetlink ];

  postPatch = ''
    substituteInPlace preloader.c --replace /usr/local/ $out/
    substituteInPlace Makefile    --replace /usr/local/ $out/
  '';

  preInstall = ''
    mkdir -p $out/bin $out/lib
  '';

  meta = with stdenv.lib; {
    description = "IPv4 and IPv6 address rate limiting evasion tool";
    homepage = https://github.com/blechschmidt/freebind;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ volth ];
  };
}
