{ lib, stdenv, fetchFromGitHub, zsh }:

# To make use of this derivation, use the `programs.zsh.autosuggestions.enable` option

stdenv.mkDerivation rec {
  pname = "zsh-autosuggestions";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-autosuggestions";
    rev = "v${version}";
    sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
  };

  strictDeps = true;
  buildInputs = [ zsh ];

  installPhase = ''
    install -D zsh-autosuggestions.zsh \
      $out/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    '';

  meta = with lib; {
    description = "Fish shell autosuggestions for Zsh";
    homepage = "https://github.com/zsh-users/zsh-autosuggestions";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.loskutov ];
  };
}
