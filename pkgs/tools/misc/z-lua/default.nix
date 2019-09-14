{ stdenv, fetchFromGitHub, lua }:

let
  lualfs = lua.withPackages (p: with p; [ luafilesystem ]);
in stdenv.mkDerivation rec {
  pname = "z-lua";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "skywind3000";
    repo = "z.lua";
    rev = "v${version}";
    sha256 = "13cfdghkprkaxgrbwsjndbza2mjxm2x774lnq7q4gfyc48mzwi70";
  };

  dontBuild = true;

  postPatch = ''
    substituteInPlace z.lua --replace \
      '.. os.interpreter() ..' \
      '.. "${lualfs}/bin/lua" ..'
  '';

  buildInputs = [ lualfs ];

  installPhase = ''
    install -Dm755 z.lua $out/bin/z
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/skywind3000/z.lua;
    description = "A new cd command that helps you navigate faster by learning your habits";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
