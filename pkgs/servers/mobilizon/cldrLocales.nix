# It may be useful in the future to expose it outside of the Mobilizon package

{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "cldr-locales";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "elixir-cldr";
    repo = "cldr";
    rev = "v${version}";
    sha256 = "0a1rmqzps4jkqdk2p728c2w417im1cmw68v15pqh9fh22gnafl8n";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp $src/priv/cldr/locales/* $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Locales provided by the ex_cldr Elixir library";
    homepage = "https://github.com/elixir-cldr/cldr";
    license = licenses.asl20;
    maintainers = with maintainers; [ minijackson ];
  };
}
