{ stdenv, fetchFromGitHub, gnused, bash, coreutils }:

stdenv.mkDerivation rec {
  name = "fish-foreign-env-${version}";
  version = "git-20170324";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-foreign-env";
    rev = "baefbd690f0b52cb8746f3e64b326d82834d07c5";
    sha256 = "0lwp6hy3kfk7xfx4xvbk1ir8zkzm7gfjbm4bf6xg1y6iw9jq9dnl";
  };

  installPhase = ''
    mkdir -p $out/share/fish-foreign-env/functions/
    cp functions/* $out/share/fish-foreign-env/functions/
    sed -e "s|sed|${gnused}/bin/sed|" \
        -e "s|bash|${bash}/bin/bash|" \
        -e "s|\| tr|\| ${coreutils}/bin/tr|" \
        -i $out/share/fish-foreign-env/functions/*
  '';

  patches = [ ./suppress-harmless-warnings.patch ];

  meta = with stdenv.lib; {
    description = "A foreign environment interface for Fish shell";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
    platforms = with platforms; unix;
  };
}
