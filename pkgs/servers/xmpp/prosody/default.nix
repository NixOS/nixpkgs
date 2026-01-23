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
  version = "13.0.3"; # also update communityModules

  src = fetchurl {
    url = "https://prosody.im/downloads/source/prosody-${finalAttrs.version}.tar.gz";
    hash = "sha256-pR7T6+VMGazWOO5fVAFKs2lsEvmf/HWsKT1p8vD/3As=";
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
    rev = "83355cfcad1d";
    hash = "sha256-v8o2FMUY2dQEQ+G81Ec4RJ7J5Mz5CkXc4iabAAb13L4=";
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

  meta = {
    description = "Open-source XMPP application server written in Lua";
    license = lib.licenses.mit;
    changelog = "https://prosody.im/doc/release/${finalAttrs.version}";
    homepage = "https://prosody.im";
    platforms = lib.platforms.linux;
    mainProgram = "prosody";
    maintainers = with lib.maintainers; [
      toastal
      mirror230469
      SuperSandro2000
    ];
  };
})
