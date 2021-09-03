{ lib
, stdenv
, fetchFromGitHub
, bison
}:

stdenv.mkDerivation rec {
  pname = "boost-build";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "boostorg";
    repo = "build";
    rev = version;
    sha256 = "1r4rwlq87ydmsdqrik4ly5iai796qalvw7603mridg2nwcbbnf54";
  };

  patches = [
    # Upstream defaults to gcc on darwin, but we use clang.
    ./darwin-default-toolset.patch
  ];

  nativeBuildInputs = [
    bison
  ];

  buildPhase = ''
    runHook preBuild
    ./bootstrap.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ./b2 install --prefix="$out"
    ln -s b2 "$out/bin/bjam"
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.boost.org/build/";
    license = lib.licenses.boost;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ivan-tkatchev ];
  };
}
