{ stdenv
, fetchFromGitHub
, lib
, nix
, nix-output-monitor
, withNotify ? stdenv.isLinux
, libnotify
, nixos-icons
}: stdenv.mkDerivation rec {
  pname = "nix-monitored";
  version = "${nix.version}-${builtins.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "ners";
    repo = "nix-monitored";
    rev = "c76769ebf25b657fb42ddc9f2e866a6a2e76d85e";
    hash = "sha256-w+MKdEiPp5BMKxmWKp30W0XSwH5+Ztw8IvRGvZgM7Pg=";
  };

  inherit (nix) outputs;

  CXXFLAGS = [
    "-O2"
    "-DNDEBUG"
  ] ++ lib.optionals withNotify [
    "-DNOTIFY"
  ];
  makeFlags = [
    "BIN=nix"
    "BINDIR=$(out)/bin"
    "NIXPATH=${lib.makeBinPath ([ nix nix-output-monitor ] ++ lib.optional withNotify libnotify) }"
  ] ++ lib.optionals withNotify [
    "NOTIFY_ICON=${nixos-icons}/share/icons/hicolor/32x32/apps/nix-snowflake.png"
  ];

  postInstall = ''
    ln -s $out/bin/nix $out/bin/nix-build
    ln -s $out/bin/nix $out/bin/nix-shell
    ls ${nix} | while read d; do
      [ -e "$out/$d" ] || ln -s ${nix}/$d $out/$d
    done
    ls ${nix}/bin | while read b; do
      [ -e $out/bin/$b ] || ln -s ${nix}/bin/$b $out/bin/$b
    done
  '' + lib.pipe nix.outputs [
    (builtins.map (o: ''
      [ -e "''$${o}" ] || ln -s ${nix.${o}} ''$${o}
    ''))
    (builtins.concatStringsSep "\n")
  ];

  # Nix will try to fixup the propagated outputs (e.g. nix-dev), to which it has
  # no write permission when building this derivation.
  # We don't actually need any fixup, as the derivation we are building is a native Nix build,
  # and all the propagated outputs have already been fixed up for the Nix derivation.
  dontFixup = true;

  meta = with lib; {
    description = "A transparent wrapper around Nix that pipes its output through Nix Output Monitor";
    homepage = "https://github.com/ners/nix-monitored";
    license = licenses.mit;
    mainProgram = "nix";
    maintainers = with maintainers; [ ners ];
    platforms = platforms.unix;
    inherit (nix.meta) outputsToInstall;
  };
}
