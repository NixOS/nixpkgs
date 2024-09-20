{ lib, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "pandoc-lua-filters";
  version = "2021-11-05";

  src = fetchFromGitHub {
    owner = "pandoc";
    repo = "lua-filters";
    rev = "v${version}";
    sha256 = "sha256-Y962kdwg2bS3ZoPfsktv4Fy34HUTRhIIuSxPi5ODwWg=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dt $out/share/pandoc/filters **/*.lua

    runHook postInstall
  '';

  meta = with lib; {
    description = "Collection of lua filters for pandoc";
    homepage = "https://github.com/pandoc/lua-filters";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.all;
  };
}
