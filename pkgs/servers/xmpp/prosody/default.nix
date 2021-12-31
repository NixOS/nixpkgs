{ stdenv, fetchurl, lib, libidn, openssl, makeWrapper, fetchhg, fetchFromGitHub
, lua
, nixosTests
, withLibevent ? true
, withDBI ? true
# use withExtraLibs to add additional dependencies of community modules
, withExtraLibs ? [ ]
, withOnlyInstalledCommunityModules ? [ ]
, withCommunityModules ? (lib.optionals withJitsiModules ["auth_token"])
, withJitsiModules ? true }:

with lib;


let
  luaEnv = lua.withPackages(p: with p; [
      luasocket luasec luaexpat luafilesystem luabitop luadbi-sqlite3
    ]
    ++ lib.optional withLibevent p.luaevent
    ++ lib.optional withDBI p.luadbi
    ++ lib.optionals withJitsiModules [p.luadbi-sqlite3 p.basexx p.otp p.luatz p.luajwtjitsi]
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

  # Be sure to update this whenever jitsi-meet is updated.
  jitsiMeet = if withJitsiModules then
    fetchFromGitHub {
      owner = "jitsi";
      repo = "jitsi-meet";
      rev = "5675";
      sha256 = "qPv7lhKxALq3gYVF8y8ooAB8AljxrpBQ4V4rLTJ6x3I=";
    }
    else null;

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
      ${lib.optionalString withJitsiModules "cp -R $jitsiMeet/resources/prosody-plugins/* $out/lib/prosody/modules/"}
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
