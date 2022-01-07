{ lib, fetchFromGitHub, fetchFromGitLab, mkYarnPackage }:

{
  kroki = mkYarnPackage rec {
    pname = "asciidoctor-kroki";
    version = "0.15.4";

    src = fetchFromGitHub {
      owner = "Mogztter";
      repo = pname;
      rev = "v${version}";
      sha256 = "lvRcizL6oUrA5x5q/JLtQlfweV0BO4dQO/MCSo0wsng=";
    };

    yarnLock = ./kroki-yarn.lock;
    yarnNix = ./kroki-yarn.nix;

    meta = with lib; {
      homepage = "https://github.com/Mogztter/asciidoctor-kroki";
      description = "Asciidoctor.js extension to convert diagrams to images using Kroki";
      license = licenses.mit;
      maintainers = with maintainers; [ Flakebi ];
    };
  };

  mathjax = mkYarnPackage rec {
    pname = "asciidoctor-mathjax.js";
    version = "unstable-2020-03-11";

    src = fetchFromGitLab {
      owner = "djencks";
      repo = pname;
      rev = "237ec1a0886b2866a9df57b6f327684d60619f76";
      sha256 = "wSAbCtQ3924/EWEVHOKnW7emaXNiBMxrFvWeRWgz1B0=";
    };

    yarnLock = ./mathjax-yarn.lock;
    yarnNix = ./mathjax-yarn.nix;

    meta = with lib; {
      homepage = "https://gitlab.com/djencks/asciidoctor-mathjax.js";
      description = "asciidoctor.js extension to render asciimath and latexmath on the server-side";
      license = licenses.mit;
      maintainers = with maintainers; [ Flakebi ];
    };
  };
}
