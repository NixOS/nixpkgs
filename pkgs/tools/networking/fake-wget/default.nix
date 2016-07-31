{ stdenv, lib, ... }:

stdenv.mkDerivation rec {

  name = "fake-wget-1.0";

  src = ./fake-wget.sh;

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp -v $src $out/bin/wget
    chmod +x $out/bin/wget
  '';

  meta = {

    description = "A fake wget implementation that does nothing";

    longDescription = ''
      Provides an executable called "wget" which prints a message and halts
      with exit code 1. This is intended for use with builds where the
      configure phase fails if it can't find wget, but where you want a
      deterministic build where nothing should actually be fetched from the
      network.
    '';

    license = with lib.licenses; [ free ];

    maintainers = with lib.maintainers; [ chris-martin ];

  };

}
