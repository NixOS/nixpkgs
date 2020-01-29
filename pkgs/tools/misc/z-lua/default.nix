{ stdenv, fetchFromGitHub, lua52Packages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "z-lua";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "skywind3000";
    repo = "z.lua";
    rev = "v${version}";
    sha256 = "0cn38sadcn65pgw6dgr59bnx9hf97011hydmpmfi3kzdqjmarwci";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ lua52Packages.lua ];

  installPhase = ''
    runHook preInstall

    install -Dm755 z.lua $out/bin/z
    wrapProgram $out/bin/z --set LUA_CPATH "${lua52Packages.luafilesystem}/lib/lua/5.2/lfs.so" --set _ZL_USE_LFS 1;

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/skywind3000/z.lua;
    description = "A new cd command that helps you navigate faster by learning your habits";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
