{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, openssl
, zlib
, zstd
, pkg-config
, python3
, xorg
, Libsystem
, AppKit
, Security
, nghttp2
, libgit2
# string interpolation dependends on a date that is erroring out
# this will be fixed in releases after 0.90.1
, doCheck ? false
, withDefaultFeatures ? true
, additionalFeatures ? (p: p)
, testers
, nushell
, nix-update-script
, makeBinaryWrapper
, plugins ? []
}:

let
  version = "0.91.0";
in

rustPlatform.buildRustPackage {
  pname = "nushell";
  inherit version;

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = version;
    hash = "sha256-X3D+JRvnk6HMKWJMTNR16Fmhu+gYd8Ip+7PZQoLIoEU=";
  };

  cargoHash = "sha256-Xj4P/qd4GvmhWGwGaPvY23cQwdjdf6cSb1xyRZLN0tQ=";

  nativeBuildInputs = [ pkg-config makeBinaryWrapper ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isLinux) [ python3 ]
    ++ lib.optionals stdenv.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = [ openssl zstd ]
    ++ lib.optionals stdenv.isDarwin [ zlib Libsystem Security ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isDarwin) [ AppKit nghttp2 libgit2 ];

  buildNoDefaultFeatures = !withDefaultFeatures;
  buildFeatures = additionalFeatures [ ];

  inherit doCheck;

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    HOME=$(mktemp -d) cargo test
    runHook postCheck
  '';

  postInstall = lib.optional (plugins != []) (
    let
      pluginRegistryPath = "$out/share/nushell/plugins.nu";
      pluginRegistrations = (map (p: ''$out/bin/nu --plugin-config ${pluginRegistryPath} -c "register ${p}/bin/${p.meta.mainProgram}"'') plugins);
    in
    ''
      mkdir -p "$(dirname ${pluginRegistryPath})"
      touch ${pluginRegistryPath}
      ${builtins.concatStringsSep "\n" pluginRegistrations}
      wrapProgram $out/bin/nu \
        --add-flags --plugin-config \
        --add-flags "${pluginRegistryPath}"
    '');

  passthru = {
    shellPath = "/bin/nu";
    tests.version = testers.testVersion {
      package = nushell;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne johntitor marsam joaquintrinanes ];
    mainProgram = "nu";
  };
}
