{ lib
, stdenv
, fetchFromGitHub
, meson
, ncurses
, ninja
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loksh";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    fetchSubmodules = true;
    sha256 = "sha256-APjY7wQUfUTXe3TRKWkDmMZuax0MpuU/KmgZfogdAGU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    ncurses
  ];

  strictDeps = true;

  postInstall = ''
    mv $out/bin/ksh $out/bin/loksh
    mv $out/share/man/man1/ksh.1 $out/share/man/man1/loksh.1
    mv $out/share/man/man1/sh.1 $out/share/man/man1/loksh-sh.1
  '';

  meta = with lib; {
    homepage = "https://github.com/dimkr/loksh";
    description = "Linux port of OpenBSD's ksh";
    longDescription = ''
      loksh is a Linux port of OpenBSD's ksh.

      Unlike other ports of ksh, loksh targets only one platform, follows
      upstream closely and keeps changes to a minimum. loksh does not add any
      extra features; this reduces the risk of introducing security
      vulnerabilities and makes loksh a good fit for resource-constrained
      systems.
    '';
    license = licenses.publicDomain;
    maintainers = with maintainers; [ cameronnemo ];
    platforms = platforms.linux;
  };

  passthru = {
    shellPath = "/bin/loksh";
  };
})
