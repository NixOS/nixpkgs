{ stdenv, lib, fetchFromGitHub, gnumake, pkg-config, wget, unzip, gawk
, sqlite, which, luaPackages, installShellFiles, makeWrapper
}:
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
    gnumake pkg-config wget unzip gawk sqlite which installShellFiles makeWrapper
  ];

  buildInputs = with luaPackages; [ lua luasql-sqlite3 luautf8 ];

  makeFlags = [
    "LUA=${luaPackages.lua}/bin/lua"
    "LUAC=${luaPackages.lua}/bin/luac"
  ];

  dontConfigure = true;

  # Can't use "make install" here
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/openrussian
    cp openrussian-sqlite3.db $out/share/openrussian
    cp openrussian $out/bin

    wrapProgram $out/bin/openrussian \
      --prefix LUA_PATH ';' "$LUA_PATH" \
      --prefix LUA_CPATH ';' "$LUA_CPATH"

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd openrussian --bash ./openrussian-completion.bash
    installManPage ./openrussian.1
  '';

  meta = with lib; {
    homepage    = "https://github.com/rhaberkorn/openrussian-cli";
    description = "Offline Console Russian Dictionary (based on openrussian.org)";
    license     = with licenses; [ gpl3Only mit cc-by-sa-40 ];
    maintainers = with maintainers; [ zane ];
    platforms   = platforms.unix;
  };
}
