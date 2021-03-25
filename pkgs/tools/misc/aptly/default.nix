{ lib, buildGoPackage, fetchFromGitHub, installShellFiles, makeWrapper, gnupg, bzip2, xz, graphviz }:

let

  version = "1.4.0";
  rev = "v${version}";

  aptlySrc = fetchFromGitHub {
    inherit rev;
    owner = "aptly-dev";
    repo = "aptly";
    sha256 = "06cq761r3bxybb9xn58jii0ggp79mcp3810z1r2z3xcvplwhwnhy";
  };

  aptlyCompletionSrc = fetchFromGitHub {
    rev = "1.0.1";
    owner = "aptly-dev";
    repo = "aptly-bash-completion";
    sha256 = "0dkc4z687yk912lpv8rirv0nby7iny1zgdvnhdm5b47qmjr1sm5q";
  };

in

buildGoPackage {
  pname = "aptly";
  inherit version;

  src = aptlySrc;

  goPackagePath = "github.com/aptly-dev/aptly";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  postInstall = ''
    installShellCompletion --bash ${aptlyCompletionSrc}/aptly
    wrapProgram "$out/bin/aptly" \
      --prefix PATH ":" "${lib.makeBinPath [ gnupg bzip2 xz graphviz ]}"
  '';

  meta = with lib; {
    homepage = "https://www.aptly.info";
    description = "Debian repository management tool";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.montag451 ];
  };
}
