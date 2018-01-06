{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "skim-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "lotabout";
    repo = "skim";
    rev = "v${version}";
    sha256 = "0spkkgjjrch1grb0115rn0wxzsh8pzmm96a7j69zy5pc1il2m5lp";
  };

  cargoSha256 = "0zbjnii8r41ih2m2vqhm3wdiwgi13kipvxx75sg4vm4maf4wpmhv";

  postInstall = ''
    install -D -m 555 bin/sk-tmux -t $out/bin
    install -D -m 444 shell/* -t $out/share/skim

    cat <<SCRIPT > $out/bin/sk-share
    #!/bin/sh
    # Run this script to find the skim shared folder where all the shell
    # integration scripts are living.
    echo $out/share/skim
    SCRIPT
    chmod +x $out/bin/sk-share
  '';

  meta = with stdenv.lib; {
    description = "Fuzzy Finder in rust!";
    homepage = https://github.com/lotabout/skim;
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
