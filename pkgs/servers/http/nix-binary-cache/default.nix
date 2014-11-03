{stdenv, fetchurl
, coreutils, findutils, nix, xz, bzip2, gnused, gnugrep, openssl
, lighttpd, iproute }:
stdenv.mkDerivation rec {
  version = "2014-06-29-1";
  name = "nix-binary-cache-${version}";

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p "$out/bin"
    substitute "${./nix-binary-cache.cgi.in}" "$out"/bin/nix-binary-cache.cgi \
      --replace @out@ "$out/bin" \
      --replace @shell@ "${stdenv.shell}" \
      --replace @coreutils@ "${coreutils}/bin" \
      --replace @findutils@ "${findutils}/bin" \
      --replace @nix@ "${nix}/bin" \
      --replace @xz@ "${xz}/bin" \
      --replace @bzip2@ "${bzip2}/bin" \
      --replace @gnused@ "${gnused}/bin" \
      --replace @gnugrep@ "${gnugrep}/bin" \
      --replace @openssl@ "${openssl}/bin" \
      --replace @lighttpd@ "${lighttpd}/sbin" \
      --replace @iproute@ "${iproute}/sbin" \
      --replace "xXxXx" "xXxXx"

    chmod a+x "$out/bin/nix-binary-cache.cgi"

    substitute "${./nix-binary-cache-start.in}" "$out"/bin/nix-binary-cache-start \
      --replace @out@ "$out/bin" \
      --replace @shell@ "${stdenv.shell}" \
      --replace @coreutils@ "${coreutils}/bin" \
      --replace @findutils@ "${findutils}/bin" \
      --replace @nix@ "${nix}/bin" \
      --replace @xz@ "${xz}/bin" \
      --replace @bzip2@ "${bzip2}/bin" \
      --replace @gnused@ "${gnused}/bin" \
      --replace @gnugrep@ "${gnugrep}/bin" \
      --replace @openssl@ "${openssl}/bin" \
      --replace @lighttpd@ "${lighttpd}/sbin" \
      --replace @iproute@ "${iproute}/sbin" \
      --replace "xXxXx" "xXxXx"

    chmod a+x "$out/bin/nix-binary-cache-start"
  '';

  meta = {
    description = ''A set of scripts to serve the Nix store as a binary cache'';
    longDescription = ''
      This package installs a CGI script that serves Nix store path in the 
      binary cache format. It also installs a launcher called 
      nix-binary-cache-start that can be run without any setup to launch
      a binary cache and get the example arguments for its usage.
    '';
    maintainers = [stdenv.lib.maintainers.raskin];
    license = stdenv.lib.licenses.gpl2Plus;
    inherit version;
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
