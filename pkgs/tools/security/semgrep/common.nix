{ lib, fetchFromGitHub, fetchzip }:

rec {
  version = "0.103.0";

  src = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep";
    rev = "v${version}";
    sha256 = "sha256-vk6GBgLsXRLAVu60xW4WWWhhi4b1WLceTxh/TeISIUg=";
  };

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  langsSrc = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep-langs";
    rev = "78e518dad1ce2a7c76854c944245434bd8426439";
    sha256 = "sha256-t9F/OzzT6FI9G4Fxz0lUjz6TVrJlenusQNJnFpiKaQs=";
  };

  interfacesSrc = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep-interfaces";
    rev = "a64a45034ea428ecbe9da6bd849a4f1cfd23cdd2";
    sha256 = "sha256-eatuyA5xyfZVHCmHvZIzQK2c5eEWUEZd9LumJQtk8+s=";
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  coreRelease = fetchzip {
    url = "https://github.com/returntocorp/semgrep/releases/download/v${version}/semgrep-v${version}-ubuntu-16.04.tgz";
    sha256 = "sha256-L3NbiVYmgJim7H4W1cr75WOItSiHT1YIkUEefuaCYlY=";
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
