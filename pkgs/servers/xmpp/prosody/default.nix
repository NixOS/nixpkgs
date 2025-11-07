{
  stdenv,
  fetchurl,
  lib,
  libidn,
  openssl,
  makeWrapper,
  fetchhg,
  buildPackages,
  icu,
  lua,
  nixosTests,
  withDBI ? true,
  # use withExtraLibs to add additional dependencies of community modules
  withExtraLibs ? [ ],
  withExtraLuaPackages ? _: [ ],
  withOnlyInstalledCommunityModules ? [ ],
  withCommunityModules ? [ ],
}:

let
  luaEnv = lua.withPackages (
    p:
    with p;
    [
      luasocket
      luasec
      luaexpat
      luafilesystem
      luabitop
      luadbi-sqlite3
      luaunbound
    ]
    ++ lib.optional withDBI p.luadbi
    ++ withExtraLuaPackages p
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prosody";
  version = "13.0.2"; # also update communityModules

  src = fetchurl {
    url = "https://prosody.im/downloads/source/prosody-${finalAttrs.version}.tar.gz";
    hash = "sha256-PmG9OW83ylJF3r/WvkmkemGRMy8Pqi1O5fAPuwQK3bA=";
  };

  # The following community modules are necessary for the nixos module
  # prosody module to comply with XEP-0423 and provide a working
  # default setup.
  nixosModuleDeps = [
    "cloud_notify"
  ];

  # A note to all those merging automated updates: Please also update this
  # attribute as some modules might not be compatible with a newer prosody
  # version.
  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules";
    rev = "a4d7fefa4a8b";
    hash = "sha256-lPxKZlIVyAt1Nx+PQ0ru0qihJ1ecBbvO0fMk+5D+NzE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    luaEnv
    libidn
    openssl
    icu
  ]
  ++ withExtraLibs;

  configureFlags = [
    "--ostype=linux"
    "--with-lua-bin=${lib.getBin buildPackages.lua}/bin"
    "--with-lua-include=${luaEnv}/include"
    "--with-lua=${luaEnv}"
    "--c-compiler=${stdenv.cc.targetPrefix}cc"
    "--linker=${stdenv.cc.targetPrefix}cc"
  ];

  configurePlatforms = [ ];

  postBuild = ''
    make -C tools/migration
  '';

  buildFlags = [
    # don't search for configs in the nix store when running prosodyctl
    "INSTALLEDCONFIG=/etc/prosody"
    "INSTALLEDDATA=/var/lib/prosody"
  ];

  # the wrapping should go away once lua hook is fixed
  postInstall = ''
    ${lib.concatMapStringsSep "\n"
      (module: ''
        cp -r ${finalAttrs.communityModules}/mod_${module} $out/lib/prosody/modules/
      '')
      (
        lib.lists.unique (
          finalAttrs.nixosModuleDeps ++ withCommunityModules ++ withOnlyInstalledCommunityModules
        )
      )
    }
    make -C tools/migration install
  '';

  passthru = {
    communityModules = withCommunityModules;
    tests = { inherit (nixosTests) prosody prosody-mysql; };
  };

  meta = with lib; {
    description = "Open-source XMPP application server written in Lua";
    license = licenses.mit;
    homepage = "https://prosody.im";
    platforms = platforms.linux;
    mainProgram = "prosody";
    maintainers = with maintainers; [
      toastal
      mirror230469
    ];
    teams = with lib.teams; [ c3d2 ];
  };
})
