{ stdenv, fetchFromGitHub, gnused, bash, coreutils }:

stdenv.mkDerivation rec {
  name = "fish-foreign-env-${version}";
  version = "git-20151223";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-foreign-env";
    rev = "2dfe5b73fd2101702c83d1d7b566e2b9332c5ddc";
    sha256 = "17jxlbljp7k2azcl1miz5h5xfyazlf9z9lrddcrnm6r7c1w1zdh5";
  };

  buildCommand = ''
    mkdir -p $out/share/fish-foreign-env/functions/
    cp $src/functions/* $out/share/fish-foreign-env/functions/
    sed -e "s|sed|${gnused}/bin/sed|" \
        -e "s|bash|${bash}/bin/bash|" \
        -e "s|\| tr|\| ${coreutils}/bin/tr|" \
        -i $out/share/fish-foreign-env/functions/*
  '';

  meta = with stdenv.lib; {
    description = "A foreign environment interface for Fish shell";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
    platforms = with platforms; unix;
  };
}
