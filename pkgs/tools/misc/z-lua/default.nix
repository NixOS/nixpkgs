{ stdenv, fetchFromGitHub, lua52Packages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "z-lua";
  version = "1.8.7";

  src = fetchFromGitHub {
    owner = "skywind3000";
    repo = "z.lua";
    rev = version;
    sha256 = "14n1abv7gh4zajq471bgzpcv8l1159g00h9x83h719i9kxxsa2ba";
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
    homepage = "https://github.com/skywind3000/z.lua";
    description = "A new cd command that helps you navigate faster by learning your habits";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
