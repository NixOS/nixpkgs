{ stdenv, lib, fetchFromGitHub, runCommand, }:

# This derivation is impure: it relies on an Xcode toolchain being installed
# and available in the expected place. The values of sandboxProfile and
# hydraPlatforms are copied pretty directly from the MacVim derivation, which
# is also impure.

let
  # Building with Swift PM requires a few system tools to be in PATH.
  buildSymlinks = runCommand "carthage-build-symlinks" {} ''
    mkdir -p $out/bin
    ln -s /usr/bin/xcrun /usr/bin/swift $out/bin
  '';

  version = "0.34.0";

  sources = {
    carthage = fetchFromGitHub {
      owner = "Carthage";
      repo = "Carthage";
      rev = "${version}";
      sha256 = "0zybynjnjn224dggrlnlcwz2bbiq3i6ljvs99qdjj863cbnj1gx6";
    };

    result = fetchFromGitHub {
      owner = "antitypical";
      repo = "result";
      rev = "4.1.0";
      sha256 = "0z0df1alvm5pa9fhk8pzcyizmk4lb5bdm0x1ak4463afr4a3n36g";
    };

    reactiveTask = fetchFromGitHub {
      owner = "Carthage";
      repo = "ReactiveTask";
      rev = "0.16.0";
      sha256 = "0yg4npym9f4sya94qnk5sz7nqqrarl6adb7iskix6cg0y87237xr";
    };

    commandant = fetchFromGitHub {
      owner = "Carthage";
      repo = "Commandant";
      rev = "0.16.0";
      sha256 = "1h7a8mjh5zhbzxqqi9wpxm1bxshnq2rvpggrkygr8liz9fpa6ghg";
    };

    prettyColors = fetchFromGitHub {
      owner = "jdhealy";
      repo = "PrettyColors";
      rev = "5.0.2";
      sha256 = "0dwf9i4zm956l15p9k4dy2692hyk60na51xlyzfyi33x9xlabpkd";
    };

    reactiveSwift = fetchFromGitHub {
      owner = "ReactiveCocoa";
      repo = "ReactiveSwift";
      rev = "5.0.0";
      sha256 = "0ikmvfs3zf0dppanwi7pwpbp0g96llj75qlas0j7kivd7pkk0l08";
    };

    tentacle = fetchFromGitHub {
      owner = "mdiep";
      repo = "Tentacle";
      rev = "0.13.1";
      sha256 = "0v0xc5ia1bwsybiq75ffpn9qva3v2mj3mqmn4xv9kjm35n0p4k7c";
    };

    curry = fetchFromGitHub {
      owner = "thoughtbot";
      repo = "Curry";
      rev = "v4.0.2";
      sha256 = "023j7av73xifpklg7wpfhz9sk93likl5rs4x3q1h81357x1ica4m";
    };

    quick = fetchFromGitHub {
      owner = "Quick";
      repo = "Quick";
      rev = "v2.1.0";
      sha256 = "1lsm46k33ry8svbm2vwsfwmgybmgwnyj2kszsq53mly6igf3ygpl";
    };

    nimble = fetchFromGitHub {
      owner = "Quick";
      repo = "Nimble";
      rev = "v8.0.1";
      sha256 = "15mrhm0cfzicnd76lg01pjdh135ilf3pi1cxynimyx2lds6c9yc9";
    };
  };

in

stdenv.mkDerivation rec {
  name = "carthage";

  nativeBuildInputs = [ buildSymlinks ];

  unpackPhase = ''
    mkdir src
    cd src

    cp -r ${sources.carthage} carthage
    cp -r ${sources.result} result
    cp -r ${sources.reactiveTask} reactiveTask
    cp -r ${sources.commandant} commandant
    cp -r ${sources.prettyColors} prettyColors
    cp -r ${sources.reactiveSwift} reactiveSwift
    cp -r ${sources.tentacle} tentacle
    cp -r ${sources.curry} curry
    cp -r ${sources.quick} quick
    cp -r ${sources.nimble} nimble

    chmod -R u+w .
  '';

  # Replace all dependencies in Project.swift to point to local copies fetched by Nix
  prePatch = ''
    substituteInPlace carthage/Package.swift --replace 'url: "https://github.com/antitypical/Result.git", from: "${sources.result.rev}"' 'path: "../result"'
    substituteInPlace carthage/Package.swift --replace 'url: "https://github.com/Carthage/ReactiveTask.git", from: "${sources.reactiveTask.rev}"' 'path: "../reactiveTask"'
    substituteInPlace carthage/Package.swift --replace 'url: "https://github.com/Carthage/Commandant.git", from: "${sources.commandant.rev}"' 'path: "../commandant"'
    substituteInPlace carthage/Package.swift --replace 'url: "https://github.com/jdhealy/PrettyColors.git", from: "${sources.prettyColors.rev}"' 'path: "../prettyColors"'
    substituteInPlace carthage/Package.swift --replace 'url: "https://github.com/ReactiveCocoa/ReactiveSwift.git", from: "${sources.reactiveSwift.rev}"' 'path: "../reactiveSwift"'
    substituteInPlace carthage/Package.swift --replace 'url: "https://github.com/mdiep/Tentacle.git", from: "${sources.tentacle.rev}"' 'path: "../tentacle"'
    substituteInPlace carthage/Package.swift --replace 'url: "https://github.com/thoughtbot/Curry.git", from: "${lib.strings.removePrefix "v" sources.curry.rev}"' 'path: "../curry"'
    substituteInPlace carthage/Package.swift --replace 'url: "https://github.com/Quick/Quick.git", from: "${lib.strings.removePrefix "v" sources.quick.rev}"' 'path: "../quick"'
    substituteInPlace carthage/Package.swift --replace 'url: "https://github.com/Quick/Nimble.git", from: "${lib.strings.removePrefix "v" sources.nimble.rev}"' 'path: "../nimble"'
  '';

  preBuild = ''
    cd carthage
  '';

  makeFlagsArray = ["installables"];

  installPhase = ''
    install -D -m 0555 .build/release/carthage $out/bin/carthage
  '';

  sandboxProfile = ''
    (allow file-read* file-write* process-exec mach-lookup)
    ; block homebrew dependencies
    (deny file-read* file-write* process-exec mach-lookup (subpath "/usr/local") (with no-log))
  '';

  meta = with lib; {
    description = "A simple, decentralized dependency manager for Cocoa";
    homepage = "https://github.com/Carthage/Carthage";
    license = licenses.mit;
    maintainers = with maintainers; [ vytis ];
    platforms = platforms.darwin;
    hydraPlatforms = [];
  };
}