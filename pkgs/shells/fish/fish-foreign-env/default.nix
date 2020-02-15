{ stdenv, fetchFromGitHub, gnused, bash, coreutils }:

stdenv.mkDerivation {
  pname = "fish-foreign-env";
  version = "git-20200209";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-foreign-env";
    rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
    sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
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
