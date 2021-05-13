{ stdenv, fetchurl, lib, libidn, openssl, makeWrapper, fetchhg
, lua5, luasocket, luasec, luaexpat, luafilesystem, luabitop
, nixosTests
, withLibevent ? true, luaevent ? null
, withDBI ? true, luadbi ? null
# use withExtraLibs to add additional dependencies of community modules
, withExtraLibs ? [ ]
, withOnlyInstalledCommunityModules ? [ ]
, withCommunityModules ? [ ] }:

assert withLibevent -> luaevent != null;
assert withDBI -> luadbi != null;

with stdenv.lib;


stdenv.mkDerivation rec {
  version = "0.11.9"; # also update communityModules
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
    sha256 = "02gzvsaq0l5lx608sfh7hfz14s6yfsr4sr4kzcsqd1cxljp35h6c";
  };

  # A note to all those merging automated updates: Please also update this
  # attribute as some modules might not be compatible with a newer prosody
  # version.
  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules";
    rev = "c149edb37349";
    sha256 = "1njw17k0nhf15hc20l28v0xzcc7jha85lqy3j97nspv9zdxmshk1";
  };

  buildInputs = [
    lua5 makeWrapper libidn openssl
  ]
  # Lua libraries
  ++ [
    luasocket luasec luaexpat luafilesystem luabitop
  ]
  ++ optional withLibevent luaevent
  ++ optional withDBI luadbi
  ++ withExtraLibs;


  configureFlags = [
    "--ostype=linux"
    "--with-lua-include=${lua5}/include"
    "--with-lua=${lua5}"
  ];

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
