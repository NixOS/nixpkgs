{ stdenv, fetchurl, lib, libidn, openssl, makeWrapper, fetchhg
, lua
, nixosTests
, withLibevent ? true
, withDBI ? true
# use withExtraLibs to add additional dependencies of community modules
, withExtraLibs ? [ ]
, withExtraLuaPackages ? _: [ ]
, withOnlyInstalledCommunityModules ? [ ]
, withCommunityModules ? [ ] }:

with lib;


let
  luaEnv = lua.withPackages(p: with p; [
      luasocket luasec luaexpat luafilesystem luabitop luadbi-sqlite3
    ]
    ++ lib.optional withLibevent p.luaevent
    ++ lib.optional withDBI p.luadbi
    ++ withExtraLuaPackages p
  );
in
stdenv.mkDerivation rec {
  version = "0.11.12"; # also update communityModules
  pname = "prosody";
  # The following community modules are necessary for the nixos module
  # prosody module to comply with XEP-0423 and provide a working
  # default setup.
  nixosModuleDeps = [
    "bookmarks"
    "cloud_notify"
    "vcard_muc"
    "smacks"
    "http_upload"
  ];
  src = fetchurl {
    url = "https://prosody.im/downloads/source/${pname}-${version}.tar.gz";
    sha256 = "03an206bl3h2lqcgv1wfvc2bqjq6m9vjb2idw0vyvczm43c55kan";
  };

  # A note to all those merging automated updates: Please also update this
  # attribute as some modules might not be compatible with a newer prosody
  # version.
  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules";
    rev = "bd0a1f917d98";
    sha256 = "0figx0b0y5zfk5anf16h20y4crjmpb6bkg30vl7p0m594qnyqjcx";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    luaEnv libidn openssl
  ]
  ++ withExtraLibs;


  configureFlags = [
    "--ostype=linux"
    "--with-lua-include=${luaEnv}/include"
    "--with-lua=${luaEnv}"
  ];

  postBuild = ''
    make -C tools/migration
  '';

  luaEnvPath = lua.pkgs.lib.genLuaPathAbsStr luaEnv;
  luaEnvCPath = lua.pkgs.lib.genLuaCPathAbsStr luaEnv;

  # the wrapping should go away once lua hook is fixed
  postInstall = ''
      ${concatMapStringsSep "\n" (module: ''
        cp -r $communityModules/mod_${module} $out/lib/prosody/modules/
      '') (lib.lists.unique(nixosModuleDeps ++ withCommunityModules ++ withOnlyInstalledCommunityModules))}
      wrapProgram $out/bin/prosody \
        --set LUA_PATH "$luaEnvPath" \
        --set LUA_CPATH "$luaEnvCPath"
      wrapProgram $out/bin/prosodyctl \
        --add-flags '--config "/etc/prosody/prosody.cfg.lua"' \
        --set LUA_PATH "$luaEnvPath" \
        --set LUA_CPATH "$luaEnvCPath"

      make -C tools/migration install
      wrapProgram $out/bin/prosody-migrator \
        --set LUA_PATH "$luaEnvPath" \
        --set LUA_CPATH "$luaEnvCPath"
    '';

  passthru = {
    communityModules = withCommunityModules;
    tests = {
      main = nixosTests.prosody;
    };
  };

  meta = {
    description = "Open-source XMPP application server written in Lua";
    license = licenses.mit;
    homepage = "https://prosody.im";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin ninjatrappeur ];
  };
}
