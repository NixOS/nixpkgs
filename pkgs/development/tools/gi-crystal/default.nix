{ lib
, fetchFromGitHub
, crystal
, gobject-introspection
}:
crystal.buildCrystalPackage rec {
  pname = "gi-crystal";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "hugopl";
    repo = "gi-crystal";
    rev = "v${version}";
    hash = "sha256-m1YW8j3e9sROykX6a4NlQUd4xyW/Ie8u35i4EIu8Wr0=";
  };

  # Make sure gi-crystal picks up the name of the so or dylib and not the leading nix store path
  # when the package name happens to start with “lib”.
  patches = [ ./src.patch ./store-friendly-library-name.patch ];

  nativeBuildInputs = [ gobject-introspection ];
  buildTargets = [ "generator" ];

  doCheck = false;
  doInstallCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r * $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "GI Crystal is a binding generator used to generate Crystal bindings for GObject based libraries using GObject Introspection.";
    homepage = "https://github.com/hugopl/gi-crystal";
    mainProgram = "gi-crystal";
    maintainers = with maintainers; [ sund3RRR ];
  };
}
