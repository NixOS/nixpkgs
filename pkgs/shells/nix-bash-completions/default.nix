{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.4";
  name = "nix-bash-completions-${version}";

  src = fetchFromGitHub {
    owner = "hedning";
    repo = "nix-bash-completions";
    rev = "v${version}";
    sha256 = "08gl9xnk738p180hpn3l7ggrz5zlky4pam7v74kb0gavjxm4fa2f";
  };

  installPhase = ''
    mkdir -p $out/share/bash-completion/completions
    cp _nix $out/share/bash-completion/completions
  '';

  meta = with stdenv.lib; {
    homepage = http://github.com/hedning/nix-bash-completions;
    description = "Bash completions for Nix, NixOS, and NixOps";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ hedning ];
  };
}
