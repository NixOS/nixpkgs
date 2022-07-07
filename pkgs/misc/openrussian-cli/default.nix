{ stdenv, lib, fetchFromGitHub, pkg-config, wget, unzip
, sqlite, which, lua, installShellFiles, makeWrapper
}:
let
  luaEnv = lua.withPackages(p: with p; [ luasql-sqlite3 luautf8 ]);
in
stdenv.mkDerivation rec {
  pname   = "openrussian-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner   = "rhaberkorn";
    repo    = "openrussian-cli";
    rev     = version;
    sha256  = "1ria7s7dpqip2wdwn35wmkry84g8ghdqnxc9cbxzzq63vl6pgvcn";
  };

  nativeBuildInputs = [
    pkg-config wget unzip sqlite which installShellFiles makeWrapper
  ];

  buildInputs = [ luaEnv ];

  makeFlags = [
    "LUA=${luaEnv}/bin/lua"
    "LUAC=${luaEnv}/bin/luac"
  ];

  dontConfigure = true;

  # Can't use "make install" here
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/openrussian
    cp openrussian-sqlite3.db $out/share/openrussian
    cp openrussian $out/bin

    wrapProgram $out/bin/openrussian \
      --prefix LUA_PATH ';' '${lua.pkgs.lib.genLuaPathAbsStr luaEnv}' \
      --prefix LUA_CPATH ';' '${lua.pkgs.lib.genLuaCPathAbsStr luaEnv}'

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd openrussian --bash ./openrussian-completion.bash
    installManPage ./openrussian.1
  '';

  meta = with lib; {
    description = "Offline Console Russian Dictionary (based on openrussian.org)";
    homepage    = "https://github.com/rhaberkorn/openrussian-cli";
    license     = with licenses; [ gpl3Only mit cc-by-sa-40 ];
    maintainers = with maintainers; [ zane ];
    mainProgram = "openrussian";
    platforms   = platforms.unix;
  };
}
