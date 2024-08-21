{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-autopair";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "hlissner";
    repo = "zsh-autopair";
    rev = "v${version}";
    sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
  };

  strictDeps = true;

  installPhase = ''
    install -D autopair.zsh $out/share/zsh/${pname}/autopair.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/hlissner/zsh-autopair";
    description = "Plugin that auto-closes, deletes and skips over matching delimiters in zsh intelligently";
    license = licenses.mit;
    maintainers = with maintainers; [ _0qq ];
    platforms = platforms.all;
  };
}
