
{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, fetchurl? pkgs.fetchurl
, fetchzip? pkgs.fetchzip
, jdk? pkgs.jdk
, makeWrapper ? pkgs.makeWrapper
}:
stdenv.mkDerivation rec {
  pname = "arthas";
  version = "3.7.1";

  inherit jdk;

  inherit (pkgs)  gawk gnused gnugrep inetutils curl;

  baseInputs = with pkgs; [gawk  inetutils curl];

  src = fetchzip {
      url = "https://github.com/alibaba/arthas/releases/download/arthas-all-${version}/arthas-bin.zip";
      hash = "sha256-dN50xjQqfo17QwaQSSPcaHo3p6AfsGRQjRJ3MSwAbLg=";
      # curlOptsList = ["-x" "http://127.0.0.1:7890"];
      stripRoot=false;
  };

  builder = "${pkgs.bash}/bin/bash";
  args = [./builder.sh ];


  postInstall = ''
        wrapProgram $out/arthas/as.sh \
    --set PATH ${lib.makeBinPath [
      pkgs.bash
      pkgs.gawk
      pkgs.gnugrep
      pkgs.curl
      pkgs.unzip
      pkgs.inetutils
      jdk
      pkgs.coreutils
    ]}
'';

  nativeBuildInputs = [ makeWrapper ];


  system = builtins.currentSystem;

  meta = with lib; {
      description = "Java Diagnostic Tool,Arthas allows developers to troubleshoot production issues for Java applications without modifying code or restarting servers.";
      homepage = "https://arthas.aliyun.com/";
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = with maintainers; [ hitsmaxft ];
  };
  }
