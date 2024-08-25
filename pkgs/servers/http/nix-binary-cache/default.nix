{lib, stdenv
, coreutils, findutils, nix, xz, bzip2, gnused, gnugrep, openssl
, lighttpd, iproute2 }:
stdenv.mkDerivation rec {
  version = "2014-06-29-1";
  pname = "nix-binary-cache";

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out/bin"
    substitute "${./nix-binary-cache.cgi.in}" "$out"/bin/nix-binary-cache.cgi \
      --replace-fail @out@ "$out/bin" \
      --replace-fail @shell@ "${stdenv.shell}" \
      --replace-fail @coreutils@ "${coreutils}/bin" \
      --replace-fail @findutils@ "${findutils}/bin" \
      --replace-fail @nix@ "${nix.out}/bin" \
      --replace-fail @xz@ "${xz.bin}/bin" \
      --replace-fail @bzip2@ "${bzip2.bin}/bin" \
      --replace-fail @gnused@ "${gnused}/bin" \
      --replace-fail @gnugrep@ "${gnugrep}/bin" \
      --replace-fail @openssl@ "${openssl.bin}/bin" \
      --replace-fail @lighttpd@ "${lighttpd}/sbin" \
      --replace-fail @iproute@ "${iproute2}/sbin" \
      --replace-fail "xXxXx" "xXxXx"

    chmod a+x "$out/bin/nix-binary-cache.cgi"

    substitute "${./nix-binary-cache-start.in}" "$out"/bin/nix-binary-cache-start \
      --replace-fail @out@ "$out/bin" \
      --replace-fail @shell@ "${stdenv.shell}" \
      --replace-fail @coreutils@ "${coreutils}/bin" \
      --replace-fail @findutils@ "${findutils}/bin" \
      --replace-fail @nix@ "${nix.out}/bin" \
      --replace-fail @xz@ "${xz.bin}/bin" \
      --replace-fail @bzip2@ "${bzip2.bin}/bin" \
      --replace-fail @gnused@ "${gnused}/bin" \
      --replace-fail @gnugrep@ "${gnugrep}/bin" \
      --replace-fail @openssl@ "${openssl.bin}/bin" \
      --replace-fail @lighttpd@ "${lighttpd}/sbin" \
      --replace-fail @iproute@ "${iproute2}/sbin" \
      --replace-fail "xXxXx" "xXxXx"

    chmod a+x "$out/bin/nix-binary-cache-start"
  '';

  meta = {
    description = "Set of scripts to serve the Nix store as a binary cache";
    longDescription = ''
      This package installs a CGI script that serves Nix store path in the
      binary cache format. It also installs a launcher called
      nix-binary-cache-start that can be run without any setup to launch
      a binary cache and get the example arguments for its usage.
    '';
    maintainers = [lib.maintainers.raskin];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    hydraPlatforms = [];
  };
}
