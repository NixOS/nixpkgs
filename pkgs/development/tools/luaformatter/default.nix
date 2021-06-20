{ cmake, fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "luaformatter";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "koihik";
    repo = "luaformatter";
    rev = version;
    sha256 = "0440kdab5i0vhlk71sbprdrhg362al8jqpy7w2vdhcz1fpi5cm0b";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp lua-format $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Code formatter for lua";
    homepage = "https://github.com/koihik/luaformatter";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
