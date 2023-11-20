{ stdenv
, lib
, fetchFromGitHub
, cmake
, doxygen
, ffmpeg
, freetype
, lua
, makeWrapper
, SDL2
, SDL2_mixer
, timidity
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corsix-th";
  version = "0.67";

  src = fetchFromGitHub {
    owner = "CorsixTH";
    repo = "CorsixTH";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WA/VJqHXzBfVUBNtxCVsGBRzSRQ0pvDvAy03ntc0KZE=";
  };

  luaEnv = lua.withPackages(p: with p; [ luafilesystem lpeg luasec luasocket ]);
  nativeBuildInputs = [ cmake doxygen makeWrapper ];
  buildInputs = [ ffmpeg freetype lua finalAttrs.luaEnv SDL2 SDL2_mixer timidity ];
  cmakeFlags = [ "-Wno-dev" ];

  postInstall = ''
    wrapProgram $out/bin/corsix-th \
    --set LUA_PATH "$LUA_PATH" \
    --set LUA_CPATH "$LUA_CPATH"
  '';

  meta = with lib; {
    description = "A reimplementation of the 1997 Bullfrog business sim Theme Hospital.";
    homepage = "https://corsixth.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ hughobrien ];
    platforms = platforms.linux;
  };
})
