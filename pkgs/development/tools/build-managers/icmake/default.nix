{ stdenv, fetchFromGitHub }:

let version = "7.22.01"; in
stdenv.mkDerivation {
  name = "icmake-${version}";

  src = fetchFromGitHub {
    sha256 = "1pgl8bami4v86ja40in4fsdx940f6q85l1s4b9k53zl29pm85v5k";
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
