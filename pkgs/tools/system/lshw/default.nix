{ stdenv
, lib
, fetchFromGitHub
, hwdata
, gtk2
, pkg-config
, gettext
, sqlite # compile GUI
, withGUI ? false
}:

stdenv.mkDerivation rec {
  pname = "lshw";
  # FIXME: when switching to a stable release:
  # Fix repology.org by not including the prefixed B, otherwise the `pname` attr
  # gets filled as `lshw-B.XX.XX` in `nix-env --query --available --attr nixpkgs.lshw --meta`
  # See https://github.com/NixOS/nix/pull/4463 for a definitive fix
  version = "unstable-2023-03-20";

  src = fetchFromGitHub {
    owner = "lyonel";
    repo = pname;
    rev = "b4e067307906ec6f277cce5c8a882f5edd03cbbc";
    #rev = "B.${version}";
    sha256 = "sha256-ahdaQeYZEFCVxwAMJPMB9bfo3ndIiqFyM6OghXwtm1A=";
  };

  nativeBuildInputs = [ pkg-config gettext ];

  buildInputs = [ hwdata ]
    ++ lib.optionals withGUI [ gtk2 sqlite ];

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=${src.rev}"
  ];

  buildFlags = [ "all" ] ++ lib.optional withGUI "gui";

  hardeningDisable = lib.optionals stdenv.hostPlatform.isStatic [ "fortify" ];

  installTargets = [ "install" ] ++ lib.optional withGUI "install-gui";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://ezix.org/project/wiki/HardwareLiSter";
    description = "Provide detailed information on the hardware configuration of the machine";
    license = licenses.gpl2;
    maintainers = with maintainers; [ thiagokokada ];
    platforms = platforms.linux;
    mainProgram = "lshw";
  };
}
