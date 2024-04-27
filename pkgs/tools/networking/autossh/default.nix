{ lib, stdenv, fetchurl, openssh }:

stdenv.mkDerivation rec {
  pname = "autossh";
  version = "1.4g";

  src = fetchurl {
    url = "http://www.harding.motd.ca/autossh/${pname}-${version}.tgz";
    sha256 = "0xqjw8df68f4kzkns5gcah61s5wk0m44qdk2z1d6388w6viwxhsz";
  };

  preConfigure = ''
    export ac_cv_func_malloc_0_nonnull=yes
    export ac_cv_func_realloc_0_nonnull=yes
  '';

  nativeBuildInputs = [ openssh ];

  installPhase = ''
    install -D -m755 autossh      $out/bin/autossh                          || return 1
    install -D -m644 CHANGES      $out/share/doc/autossh/CHANGES            || return 1
    install -D -m644 README       $out/share/doc/autossh/README             || return 1
    install -D -m644 autossh.host $out/share/autossh/examples/autossh.host  || return 1
    install -D -m644 rscreen      $out/share/autossh/examples/rscreen       || return 1
    install -D -m644 autossh.1    $out/man/man1/autossh.1                   || return 1
  '';

  meta = with lib; {
    homepage = "https://www.harding.motd.ca/autossh/";
    description = "Automatically restart SSH sessions and tunnels";
    license = licenses.bsd1;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
    mainProgram = "autossh";
  };
}
