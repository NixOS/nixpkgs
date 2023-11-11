{ stdenv, fetchurl, lib, libidn, openssl, makeWrapper, fetchhg, buildPackages
, icu
, lua
, nixosTests
, withDBI ? true
# use withExtraLibs to add additional dependencies of community modules
, withExtraLibs ? [ ]
, withExtraLuaPackages ? _: [ ]
, withOnlyInstalledCommunityModules ? [ ]
, withCommunityModules ? [ ] }:

with lib;

let
  luaEnv = lua.withPackages(p: with p; [
      luasocket luasec luaexpat luafilesystem luabitop luadbi-sqlite3 luaunbound
    ]
    ++ lib.optional withDBI p.luadbi
    ++ withExtraLuaPackages p
  );
in
stdenv.mkDerivation rec {
  version = "0.12.4"; # also update communityModules
  pname = "prosody";
  # The following community modules are necessary for the nixos module
  # prosody module to comply with XEP-0423 and provide a working
  # default setup.
  nixosModuleDeps = [
    "cloud_notify"
    "vcard_muc"
    "http_upload"
  ];
  src = fetchurl {
    url = "https://prosody.im/downloads/source/${pname}-${version}.tar.gz";
    sha256 = "R9cSJzwvKVWMQS9s2uwHMmC7wmt92iQ9tYAzAYPWWFY=";
  };

  # A note to all those merging automated updates: Please also update this
  # attribute as some modules might not be compatible with a newer prosody
  # version.
  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules";
    rev = "d3a72777f149";
    hash = "sha256-qLuhEdvtOMfu78oxLUZKWZDb/AME1+IRnk0jkQNxTU8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    luaEnv libidn openssl icu
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
  configurePlatforms = [];

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
      ${concatMapStringsSep "\n" (module: ''
        cp -r $communityModules/mod_${module} $out/lib/prosody/modules/
      '') (lib.lists.unique(nixosModuleDeps ++ withCommunityModules ++ withOnlyInstalledCommunityModules))}
      wrapProgram $out/bin/prosodyctl \
        --add-flags '--config "/etc/prosody/prosody.cfg.lua"'
      make -C tools/migration install
    '';

  passthru = {
    communityModules = withCommunityModules;
    tests = { inherit (nixosTests) prosody prosody-mysql; };
  };

  meta = {
    description = "Open-source XMPP application server written in Lua";
    license = licenses.mit;
    homepage = "https://prosody.im";
    platforms = platforms.linux;
    maintainers = with maintainers; [ toastal ];
  };
}
