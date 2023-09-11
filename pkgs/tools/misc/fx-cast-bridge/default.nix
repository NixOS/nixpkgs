{ lib, buildNpmPackage, fetchFromGitHub, avahi-compat, nodejs, python3 }:

buildNpmPackage rec {
  pname = "fx-cast-bridge";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "hensm";
    repo = "fx_cast";
    rev = "v${version}";
    hash = "sha256-hB4NVJW2exHoKsMp0CKzHerYgj8aR77rV+ZsCoWA1Dg=";
  };
  sourceRoot = "${src.name}/app";
  npmDepsHash = "sha256-GLrDRZqKcX1PDGREx+MLZ1TEjr88r9nz4TvZ9nvo40g=";

  nativeBuildInputs = [ python3 ];
  buildInputs = [ avahi-compat ];

  postPatch = ''
    substituteInPlace bin/lib/paths.js \
      --replace "../../../" "../../"
  '';

  dontNpmInstall = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/mozilla/native-messaging-hosts}

    substituteInPlace dist/app/fx_cast_bridge.json \
      --replace "$(realpath dist/app/fx_cast_bridge.sh)" "$out/bin/fx_cast_bridge"
    mv dist/app/fx_cast_bridge.json $out/lib/mozilla/native-messaging-hosts

    rm dist/app/fx_cast_bridge.sh
    mv dist/app $out/lib/fx_cast_bridge
    mv node_modules $out/lib/fx_cast_bridge/node_modules

    echo "#! /bin/sh
    NODE_PATH=\"$out/lib/node_modules\" \\
      exec ${nodejs}/bin/node \\
      $out/lib/fx_cast_bridge/src/main.js \\
      --_name fx_cast_bridge \"\$@\"
    " >$out/bin/fx_cast_bridge
    chmod +x $out/bin/fx_cast_bridge

    runHook postInstall
  '';

  meta = with lib; {
    description = "Implementation of the Chrome Sender API (Chromecast) within Firefox";
    homepage = "https://hensm.github.io/fx_cast/";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill pedrohlc ];
  };
}
