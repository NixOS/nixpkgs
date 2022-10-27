{ lib, stdenv, fetchFromGitHub, lua52Packages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "z-lua";
  version = "1.8.16";

  src = fetchFromGitHub {
    owner = "skywind3000";
    repo = "z.lua";
    rev = version;
    sha256 = "sha256-VVJXBVENXlJXVj831Hx4sa7AzGHXpsui6tga9uA6ZnE=";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ lua52Packages.lua ];

  installPhase = ''
    runHook preInstall

    install -Dm755 z.lua $out/bin/z.lua
    wrapProgram $out/bin/z.lua --set LUA_CPATH "${lua52Packages.luafilesystem}/lib/lua/5.2/lfs.so" --set _ZL_USE_LFS 1;
    # Create symlink for backwards compatibility. See: https://github.com/NixOS/nixpkgs/pull/96081
    ln -s $out/bin/z.lua $out/bin/z

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/skywind3000/z.lua";
    description = "A new cd command that helps you navigate faster by learning your habits";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
    mainProgram = "z.lua";
  };
}
