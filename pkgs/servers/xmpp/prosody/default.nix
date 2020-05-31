{ stdenv, fetchurl, libidn, openssl, makeWrapper, fetchhg
, lua5, luasocket, luasec, luaexpat, luafilesystem, luabitop
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
  version = "0.11.5"; # also update communityModules
  pname = "prosody";

  src = fetchurl {
    url = "https://prosody.im/downloads/source/${pname}-${version}.tar.gz";
    sha256 = "12s0hn6hvjbi61cdw3165l6iw0878971dmlvfg663byjsmjvvy2m";
  };

  # A note to all those merging automated updates: Please also update this
  # attribute as some modules might not be compatible with a newer prosody
  # version.
  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules";
    rev = "acd231e2b46f";
    sha256 = "1b33lsxrrrvarknqz9xs7j7f19bzxxymmfdhch7k70x3yyiwmfsy";
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
      '') (withCommunityModules ++ withOnlyInstalledCommunityModules)}
      wrapProgram $out/bin/prosody \
        --prefix LUA_PATH ';' "$LUA_PATH" \
        --prefix LUA_CPATH ';' "$LUA_CPATH"
      wrapProgram $out/bin/prosodyctl \
        --add-flags '--config "/etc/prosody/prosody.cfg.lua"' \
        --prefix LUA_PATH ';' "$LUA_PATH" \
        --prefix LUA_CPATH ';' "$LUA_CPATH"
    '';

  passthru.communityModules = withCommunityModules;

  meta = {
    description = "Open-source XMPP application server written in Lua";
    license = licenses.mit;
    homepage = "https://prosody.im";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
