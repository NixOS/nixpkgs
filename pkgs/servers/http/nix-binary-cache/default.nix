{lib, stdenv
, coreutils, findutils, nix, xz, bzip2, gnused, gnugrep, openssl
, lighttpd, iproute2 }:
stdenv.mkDerivation rec {
  version = "2014-06-29-1";
  pname = "nix-binary-cache";

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p "$out/bin"
    substitute "${./nix-binary-cache.cgi.in}" "$out"/bin/nix-binary-cache.cgi \
      --replace @out@ "$out/bin" \
      --replace @shell@ "${stdenv.shell}" \
      --replace @coreutils@ "${coreutils}/bin" \
      --replace @findutils@ "${findutils}/bin" \
      --replace @nix@ "${nix.out}/bin" \
      --replace @xz@ "${xz.bin}/bin" \
      --replace @bzip2@ "${bzip2.bin}/bin" \
      --replace @gnused@ "${gnused}/bin" \
      --replace @gnugrep@ "${gnugrep}/bin" \
      --replace @openssl@ "${openssl.bin}/bin" \
      --replace @lighttpd@ "${lighttpd}/sbin" \
      --replace @iproute@ "${iproute2}/sbin" \
      --replace "xXxXx" "xXxXx"

    chmod a+x "$out/bin/nix-binary-cache.cgi"

    substitute "${./nix-binary-cache-start.in}" "$out"/bin/nix-binary-cache-start \
      --replace @out@ "$out/bin" \
      --replace @shell@ "${stdenv.shell}" \
      --replace @coreutils@ "${coreutils}/bin" \
      --replace @findutils@ "${findutils}/bin" \
      --replace @nix@ "${nix.out}/bin" \
      --replace @xz@ "${xz.bin}/bin" \
      --replace @bzip2@ "${bzip2.bin}/bin" \
      --replace @gnused@ "${gnused}/bin" \
      --replace @gnugrep@ "${gnugrep}/bin" \
      --replace @openssl@ "${openssl.bin}/bin" \
      --replace @lighttpd@ "${lighttpd}/sbin" \
      --replace @iproute@ "${iproute2}/sbin" \
      --replace "xXxXx" "xXxXx"

    chmod a+x "$out/bin/nix-binary-cache-start"
  '';

  meta = {
    description = "A set of scripts to serve the Nix store as a binary cache";
    longDescription = ''
      This package installs a CGI script that serves Nix store path in the
      binary cache format. It also installs a launcher called
      nix-binary-cache-start that can be run without any setup to launch
      a binary cache and get the example arguments for its usage.
    '';
    maintainers = [lib.maintainers.raskin];
    license = lib.licenses.gpl2Plus;
    inherit version;
    platforms = lib.platforms.all;
    hydraPlatforms = [];
  };
}
