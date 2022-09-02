{ stdenv, fetchurl, lib, libidn, openssl, makeWrapper, fetchhg
, icu
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
      luasocket luasec luaexpat luafilesystem luabitop luadbi-sqlite3 luaunbound
    ]
    ++ lib.optional withLibevent p.luaevent
    ++ lib.optional withDBI p.luadbi
    ++ withExtraLuaPackages p
  );
in
stdenv.mkDerivation rec {
  version = "0.12.0"; # also update communityModules
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
    sha256 = "sha256-dS/zIBXaxWX8NBfCGWryaJccNY7gZuUfXZEkE1gNiJo=";
  };

  # A note to all those merging automated updates: Please also update this
  # attribute as some modules might not be compatible with a newer prosody
  # version.
  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules";
    rev = "65438e4ba563";
    sha256 = "sha256-zHOrMzcgHOdBl7nObM+OauifbcmKEOfAuj81MDSoLMk=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    luaEnv libidn openssl icu
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
    maintainers = with maintainers; [ globin ];
  };
}
