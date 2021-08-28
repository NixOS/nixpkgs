{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "cde";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "corr-CDE";
    rev = "v${version}";
    sha256 = "sha256-s375gtqBWx0GGXALXR+fN4bb3tmpvPNu/3bNz+75UWU=";
  };

  # The build is small, so there should be no problem
  # running this locally. There is also a use case for
  # older systems, where modern binaries might not be
  # useful.
  preferLocalBuild = true;

  patchBuild = ''
    sed -i -e '/install/d' $src/Makefile
  '';

  preBuild = ''
    patchShebangs .
  '';

  installPhase = ''
    install -d $out/bin
    install -t $out/bin cde cde-exec
  '';

  meta = with lib; {
    homepage = "https://pg.ucsd.edu/cde/manual/";
    description = "A packaging tool for building portable packages";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.rlupton20 ];
    platforms = platforms.linux;
    # error: architecture aarch64 is not supported by strace
    badPlatforms = [ "aarch64-linux" ];
  };
}
