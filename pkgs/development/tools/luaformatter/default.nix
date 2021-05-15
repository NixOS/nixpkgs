{ cmake, fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "luaformatter";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "koihik";
    repo = "luaformatter";
    rev = version;
    sha256 = "163190g37r6npg5k5mhdwckdhv9nwy2gnfp5jjk8p0s6cyvydqjw";
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
