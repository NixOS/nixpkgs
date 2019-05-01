with 
  import <nixpkgs> {}
;

stdenv.mkDerivation {
  name = "pplatex";
  version = "1.0-rc2";

  src = fetchFromGitHub {
    owner = "stefanhepp";
    repo = "pplatex";
    rev = "25bf7e121178f1fee2452b4fa9961248a045a387";
    sha256 = "0xw7nvi2l15iyp9sm8vmmqghi54v99bcivqvx89f5v2gw0kw47k3";
  };

  buildInputs = 
  [
    pkgs.cmake
    pkgs.gnumake
    pkgs.pkgconfig
    pkgs.pcre 
    pkgs.texlive.combined.scheme-small 
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/pplatex $out/bin
  '';
  
    meta = {
    description = "TeX/LaTeX family error parser";
    longDescription = ''
      pplatex is a program that displays errors from TeX/LaTeX family programs in a user friendly format.
    '';
    homepage = https://github.com/stefanhepp/pplatex;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.srgom ];
    platforms = stdenv.lib.platforms.linux;
  };
}
