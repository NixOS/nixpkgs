{ stdenv, fetchurl, zsh }:

# To make use of this derivation, use the `programs.zsh.enableSyntaxHighlighting` option

let

  pkgName = "zsh-syntax-highlighting";
  version = "0.4.1";

in

stdenv.mkDerivation rec {
  name = "${pkgName}-${version}";

  src = fetchurl {
    url = "https://github.com/zsh-users/${pkgName}/archive/${version}.tar.gz";
    sha256 = "15sih7blqz11d8wdybx38d91vgcq9jg3q0205r26138si0g9q6wp";
  };

  buildInputs = [ zsh ];

  installFlags="PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Fish shell like syntax highlighting for Zsh";
    homepage = "https://github.com/zsh-users/zsh-syntax-highlighting";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.loskutov ];
  };
}
