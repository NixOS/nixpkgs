{ lib, fetchFromGitHub, fetchzip }:

rec {
  version = "0.106.0";

  src = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep";
    rev = "v${version}";
    sha256 = "sha256-/L8w8imvfjO3ICe0FBhfVrTivK58/9Y+j9Hc71tlpjA=";
  };

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  langsSrc = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep-langs";
    rev = "98e4aacb0d58539b50a642a28d916a5d749e2a42";
    sha256 = "sha256-7w+8vLmzqBjbeV+a4Br7kLQ2bJv3aZJw8cB0R9d/D+E=";
  };

  interfacesSrc = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep-interfaces";
    rev = "8bc79b2bca62c051e46a33fb65751357a71b87b6";
    sha256 = "sha256-k/rsTGYqHnw/4bsmeg7pQ/ckNglvuA0yhuz+OayXCdw=";
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  coreRelease = fetchzip {
    url = "https://github.com/returntocorp/semgrep/releases/download/v${version}/semgrep-v${version}-ubuntu-16.04.tgz";
    sha256 = "sha256-ARf776uOJkCBGsJI8ul3IDWI24vFQxs2jlGEA6uXG+o=";
  };

  meta = with lib; {
    homepage = "https://semgrep.dev/";
    downloadPage = "https://github.com/returntocorp/semgrep/";
    changelog = "https://github.com/returntocorp/semgrep/blob/v${version}/CHANGELOG.md";
    description = "Lightweight static analysis for many languages";
    longDescription = ''
      Semgrep is a fast, open-source, static analysis tool for finding bugs and
      enforcing code standards at editor, commit, and CI time. Semgrep analyzes
      code locally on your computer or in your build environment: code is never
      uploaded. Its rules look like the code you already write; no abstract
      syntax trees, regex wrestling, or painful DSLs.
    '';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jk ambroisie ];
    # limited by semgrep-core
    platforms = [ "x86_64-linux" ];
  };
}
