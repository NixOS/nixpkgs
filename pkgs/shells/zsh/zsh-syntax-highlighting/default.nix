{ lib, stdenv, fetchFromGitHub, zsh }:

# To make use of this derivation, use the `programs.zsh.enableSyntaxHighlighting` option

stdenv.mkDerivation rec {
  version = "0.7.1";
  pname = "zsh-syntax-highlighting";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-syntax-highlighting";
    rev = version;
    sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
  };

  strictDeps = true;
  buildInputs = [ zsh ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Fish shell like syntax highlighting for Zsh";
    homepage = "https://github.com/zsh-users/zsh-syntax-highlighting";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.loskutov ];
  };
}
