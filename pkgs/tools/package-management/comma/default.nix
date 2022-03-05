{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, linkFarm
, nix-index
, fzy
}:

let

  # nix-index takes a little while to run and the contents don't change
  # meaningfully very often.
  indexCache = fetchurl {
    url = "https://github.com/Mic92/nix-index-database/releases/download/2021-12-12/index-x86_64-linux";
    sha256 = "sha256-+SoG5Qz2KWA/nIWXE6SLpdi8MDqTs8LY90fGZxGKOiA=";
  };

  # nix-locate needs the --db argument to be a directory containing a file
  # named "files".
  nixIndexDB = linkFarm "nix-index-cache" [
    { name = "files"; path = indexCache; }
  ];

in stdenv.mkDerivation rec {
  pname = "comma";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = version;
    sha256 = "sha256-WBIQmwlkb/GMoOq+Dnyrk8YmgiM/wJnc5HYZP8Uw72E=";
  };

  postPatch = ''
    substituteInPlace , \
      --replace '$PREBUILT_NIX_INDEX_DB' "${nixIndexDB}" \
      --replace nix-locate "${nix-index}/bin/nix-locate" \
      --replace fzy "${fzy}/bin/fzy"
  '';

  installPhase = ''
    install -Dm755 , -t $out/bin
    ln -s $out/bin/, $out/bin/comma
  '';

  meta = with lib; {
    homepage = "https://github.com/nix-community/comma";
    description = "Run software without installing it";
    license = licenses.mit;
    maintainers = with maintainers; [ Enzime ];
    platforms = platforms.all;
  };
}
