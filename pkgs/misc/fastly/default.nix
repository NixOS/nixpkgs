{ stdenv, fetchurl, writeShellScript, lib, installShellFiles, curl, jq, common-updater-scripts }:

let
  pname = "fastly";
  version = "2.0.0";

  sources = {
    "x86_64-linux" = fetchurl {
      url = "https://github.com/fastly/cli/releases/download/${version}/fastly_v${version}_linux-amd64.tar.gz";
      sha256 = "1498y544hr3dfhkql7prknwrv3s6v1g9qh9iw18s320qz6w47233";
    };
    "i686-linux" = fetchurl {
      url = "https://github.com/fastly/cli/releases/download/${version}/fastly_v${version}_linux-386.tar.gz";
      sha256 = "0zfpad0lv63qbw2y1zligcx98rgzydlxx7prdbd2f1pbbpiqznrv";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/fastly/cli/releases/download/${version}/fastly_v${version}_linux-arm64.tar.gz";
      sha256 = "1s369i1f0ww72902pn3apxc0xvcmn6k4q1m7ms1ialxjwmsa95qx";
    };
    "aarch64-darwin" = fetchurl {
      url = "https://github.com/fastly/cli/releases/download/${version}/fastly_v${version}_darwin-arm64.tar.gz";
      sha256 = "1h2iypjzsc3nfdf7fbdlb88sm70dgfsxicr6z260d1q3qd71q75j";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/fastly/cli/releases/download/${version}/fastly_v${version}_darwin-amd64.tar.gz";
      sha256 = "19h8b1skwgdqps6bj9gm11p5j4365256za3lk5mqy3fq7sgxdywa";
    };
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = sources.${stdenv.hostPlatform.system};

  setSourceRoot = ''
    sourceRoot=$PWD
  '';

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    HOME=/tmp ./fastly --completion-script-zsh > fastly.zsh
    HOME=/tmp ./fastly --completion-script-bash > fastly.bash

    installShellCompletion fastly.{bash,zsh}

    mkdir -p $out/bin
    install fastly $out/bin/fastly

    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line tool for interacting with the Fastly API";
    license = licenses.asl20;
    homepage = "https://github.com/fastly/cli";
    maintainers = with maintainers; [ shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
