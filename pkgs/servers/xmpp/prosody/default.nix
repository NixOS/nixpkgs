{ stdenv, fetchurl, lib, libidn, openssl, makeWrapper, fetchhg
, lua
, nixosTests
, withLibevent ? true
, withDBI ? true
# use withExtraLibs to add additional dependencies of community modules
, withExtraLibs ? [ ]
, withOnlyInstalledCommunityModules ? [ ]
, withCommunityModules ? [ ] }:

with lib;


let
  luaEnv = lua.withPackages(p: with p; [
      luasocket luasec luaexpat luafilesystem luabitop luadbi-sqlite3
    ]
    ++ lib.optional withLibevent p.luaevent
    ++ lib.optional withDBI p.luadbi
  );
in
stdenv.mkDerivation rec {
  version = "0.11.10"; # also update communityModules
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
    sha256 = "1q84s9cq7cgzd295qxa2iy0r3vd3v3chbck62bdx3pd6skk19my6";
  };

  # A note to all those merging automated updates: Please also update this
  # attribute as some modules might not be compatible with a newer prosody
  # version.
  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules";
    rev = "64fafbeba14d";
    sha256 = "02gj1b8sdmdvymsdmjpq47zrl7sg578jcdxbbq18s44f3njmc9q1";
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

  # the wrapping should go away once lua hook is fixed
  postInstall = ''
      ${concatMapStringsSep "\n" (module: ''
        cp -r $communityModules/mod_${module} $out/lib/prosody/modules/
      '') (lib.lists.unique(nixosModuleDeps ++ withCommunityModules ++ withOnlyInstalledCommunityModules))}
      wrapProgram $out/bin/prosody \
        --prefix LUA_PATH ';' "$LUA_PATH" \
        --prefix LUA_CPATH ';' "$LUA_CPATH"
      wrapProgram $out/bin/prosodyctl \
        --add-flags '--config "/etc/prosody/prosody.cfg.lua"' \
        --prefix LUA_PATH ';' "$LUA_PATH" \
        --prefix LUA_CPATH ';' "$LUA_CPATH"

      make -C tools/migration install
      wrapProgram $out/bin/prosody-migrator \
        --prefix LUA_PATH ';' "$LUA_PATH" \
        --prefix LUA_CPATH ';' "$LUA_CPATH"
    '';

  passthru = {
    communityModules = withCommunityModules;
    tests = {
      main = nixosTests.prosody;
      mysql = nixosTests.prosodyMysql;
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
