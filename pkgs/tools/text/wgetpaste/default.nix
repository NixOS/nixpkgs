{stdenv, fetchurl, wget, bash, coreutils}:
  stdenv.mkDerivation rec {
    version = "2.18";
    name = "wgetpaste-${version}";
      src = fetchurl {
        url = "http://wgetpaste.zlin.dk/${name}.tar.bz2";
        sha256 = "95ee46eac37ca74ce960c1726afc19f4a1dde4d1875ac860fdc5e45d3cb05d3e";
    };
    # currently zsh-autocompletion support is not installed

    prePatch = ''
      substituteInPlace wgetpaste --replace "/usr/bin/env bash" "${bash}/bin/bash"
    '';

    installPhase = ''
      mkdir -p $out/bin;
      cp wgetpaste $out/bin;
    '';

    meta = {
      description = "wgetpaste";
      homepage = http://wgetpaste.zlin.dk/;
      license = "publicDomain";
      maintainers = with stdenv.lib.maintainers; [qknight];
    };
  }
