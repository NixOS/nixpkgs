{ lib, fetchFromGitHub, fetchzip, stdenv }:

rec {
  version = "0.108.0";

  src = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep";
    rev = "v${version}";
    sha256 = "sha256-Vdrv7lVPsBsxkwwfviD5zRAdsD02RfWmM+IlaThduQs=";
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
    rev = "bad298d06a5dc50e69b6818ba73f0cc9b9a17b58";
    sha256 = "sha256-AgNSvjVsP4b4zwkmq6BoNcOX3xdCSnQmXK+fVSkDXxQ=";
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  coreRelease = if stdenv.isDarwin then fetchzip {
      url = "https://github.com/returntocorp/semgrep/releases/download/v${version}/semgrep-v${version}-osx.zip";
      sha256 = "sha256-f3ah4yGvtUL3Ievz+3hhh5Am1YMplRxsRQzdRAoF9uU=";
  } else fetchzip {
      url = "https://github.com/returntocorp/semgrep/releases/download/v${version}/semgrep-v${version}-ubuntu-16.04.tgz";
      sha256 = "sha256-qie9svlzRoAsI33W+Sxh4YTVk1iPV0NVXfzfKlEUul4=";
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
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
