{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper, gnupg1compat, bzip2, xz, graphviz }:

let

  version = "1.1.1";
  rev = "v${version}";

  aptlySrc = fetchFromGitHub {
    inherit rev;
    owner = "smira";
    repo = "aptly";
    sha256 = "197a7nh8li20slqxgn8s8xm13x5b8ansmabk8rx32sngb73hp4av";
  };

  aptlyCompletionSrc = fetchFromGitHub {
    rev = "1.0.1";
    owner = "aptly-dev";
    repo = "aptly-bash-completion";
    sha256 = "0dkc4z687yk912lpv8rirv0nby7iny1zgdvnhdm5b47qmjr1sm5q";
  };

in

buildGoPackage {
  name = "aptly-${version}";

  src = aptlySrc;

  goPackagePath = "github.com/smira/aptly";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
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
