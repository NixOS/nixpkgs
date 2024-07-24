{ lib, stdenv, fetchFromGitHub, raylib, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Cocoa;
in
stdenv.mkDerivation rec {
  pname = "raylib-games";
  version = "2022-10-24";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = pname;
    rev = "e00d77cf96ba63472e8316ae95a23c624045dcbe";
    hash = "sha256-N9ip8yFUqXmNMKcvQuOyxDI4yF/w1YaoIh0prvS4Xr4=";
  };

  buildInputs = [ raylib ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  configurePhase = ''
    runHook preConfigure
    for d in *; do
      if [ -d $d/src/resources ]; then
        for f in $d/src/*.c $d/src/*.h; do
          sed "s|\"resources/|\"$out/resources/$d/|g" -i $f
        done
      fi
    done
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    for d in *; do
      if [ -f $d/src/Makefile ]; then
        make -C $d/src
      fi
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preBuild
    mkdir -p $out/bin $out/resources
    find . -type f -executable -exec cp {} $out/bin \;
    for d in *; do
      if [ -d "$d/src/resources" ]; then
        cp -ar "$d/src/resources" "$out/resources/$d"
      fi
    done
    runHook postBuild
  '';

  meta = with lib; {
    description = "Collection of games made with raylib ";
    homepage = "https://www.raylib.com/games.html";
    license = licenses.zlib;
    maintainers = with maintainers; [ ehmry ];
    inherit (raylib.meta) platforms;
  };
}
