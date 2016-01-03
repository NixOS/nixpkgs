{stdenv, clang, fetchurl, curl}:

stdenv.mkDerivation {
  name = "tldr-1.0";
  buildInputs = [curl clang];
  preBuild = ''
  cd src;
  '';
  installPhase = ''
  install -d $prefix/bin;
  install tldr $prefix/bin;
  '';
  src = fetchurl {
    url = "https://github.com/tldr-pages/tldr-cpp-client/archive/v1.0.tar.gz";
    sha256 = "11k2pc4vfhx9q3cfd1145sdwhis9g0zhw4qnrv7s7mqnslzrrkgw";
  };
}
