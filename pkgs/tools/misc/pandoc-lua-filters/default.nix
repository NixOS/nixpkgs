{ lib, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "pandoc-lua-filters";
  version = "2020-11-30";

  src = fetchFromGitHub {
    owner = "pandoc";
    repo = "lua-filters";
    rev = "v${version}";
    sha256 = "HWBlmlIuJOSgRVrUmXOAI4XTxs1PbZhcwZgZFX0x2wM=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dt $out/share/pandoc/filters **/*.lua

    runHook postInstall
  '';

  meta = with lib; {
    description = "A collection of lua filters for pandoc";
    homepage = "https://github.com/pandoc/lua-filters";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.all;
  };
}
