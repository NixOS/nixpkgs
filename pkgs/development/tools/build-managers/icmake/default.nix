{ stdenv, fetchFromGitHub }:

let version = "7.23.02"; in
stdenv.mkDerivation {
  name = "icmake-${version}";

  src = fetchFromGitHub {
    sha256 = "0gp2f8bw9i7vccsbz878mri0k6fls2x8hklbbr6mayag397gr928";
    rev = version;
    repo = "icmake";
    owner = "fbb-git";
  };

  sourceRoot = "icmake-${version}-src/icmake";

  preConfigure = ''
    patchShebangs ./
    substituteInPlace INSTALL.im --replace "usr/" ""
  '';

  buildPhase = ''
    ./icm_bootstrap $out
  '';

  installPhase = ''
    ./icm_install all /
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "A program maintenance (make) utility using a C-like grammar";
    homepage = https://fbb-git.github.io/icmake/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ nckx pSub ];
    platforms = platforms.linux;
  };
}
