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
  version = "0.11.3"; # also update communityModules
  pname = "prosody";

  src = fetchurl {
    url = "https://prosody.im/downloads/source/${pname}-${version}.tar.gz";
    sha256 = "11xz4milv2962qf75vrdwsvd8sy2332nf69202rmvz5989pvvnng";
  };

  # A note to all those merging automated updates: Please also update this
  # attribute as some modules might not be compatible with a newer prosody
  # version.
  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules";
    rev = "b54e98d5c4a1";
    sha256 = "0bzn92j48krb2zhp9gn5bbn5sg0qv15j5lpxfszwqdln3lpmrvzg";
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
    homepage = https://prosody.im;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
