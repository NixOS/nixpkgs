{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper, gnupg1compat, bzip2, xz, graphviz }:

let

  version = "0.9.7";
  rev = "v${version}";

  aptlySrc = fetchFromGitHub {
    inherit rev;
    owner = "smira";
    repo = "aptly";
    sha256 = "0j1bmqdah4i83r2cf8zcq87aif1qg90yasgf82yygk3hj0gw1h00";
  };

  aptlyCompletionSrc = fetchFromGitHub {
    rev = version;
    owner = "aptly-dev";
    repo = "aptly-bash-completion";
    sha256 = "1yz3pr2jfczqv81as2q3cizwywj5ksw76vi15xlbx5njkjp4rbm4";
  };

in

buildGoPackage {
  name = "aptly-${version}";

  src = aptlySrc;

  goPackagePath = "github.com/smira/aptly";
  goDeps = ./deps.nix;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    rm $bin/bin/man
    mkdir -p $bin/share/bash-completion/completions
    ln -s ${aptlyCompletionSrc}/aptly $bin/share/bash-completion/completions
    wrapProgram "$bin/bin/aptly" \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ gnupg1compat bzip2 xz graphviz ]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://www.aptly.info;
    description = "Debian repository management tool";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.montag451 ];
  };
}
