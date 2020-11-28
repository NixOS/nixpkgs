{ stdenv, fetchFromGitHub, runtimeShell, zsh }:

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

  buildInputs = [ zsh ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p $out/bin
    cat <<SCRIPT > $out/bin/zsh-syntax-highlighting-share
    #!${runtimeShell}
    # Run this script to find the zsh-syntax-highlighting shared folder where
    # all the shell integration scripts are living.
    echo $out/share/zsh-syntax-highlighting
    SCRIPT
    chmod +x $out/bin/zsh-syntax-highlighting-share
  '';

  meta = with stdenv.lib; {
    description = "Fish shell like syntax highlighting for Zsh";
    homepage = "https://github.com/zsh-users/zsh-syntax-highlighting";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.loskutov ];
  };
}
