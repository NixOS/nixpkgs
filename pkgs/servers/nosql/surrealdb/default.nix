{ stdenv, lib, llvm, fetchFromGitHub, openssl, zlib, rustPlatform, binutils, cmake, protobuf, perl, llvmPackages, qemu }:

let
  common = { version, sha256 }: rustPlatform.buildRustPackage {
    pname = "surrealdb";
    inherit version;

    src = fetchFromGitHub {
      repo = "surrealdb";
      owner = "surrealdb";
      rev = "${version}";
      inherit sha256;
    };
    PROTOC = "${protobuf}/bin/protoc";
    PROTOBUF_ROOT_DIR = "${protobuf}";
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

    nativeBuildInputs = [ cmake llvm perl qemu binutils ];
    buildInputs = [ openssl zlib protobuf ];
    cargoSha256 = "sha256-KnBmGyUCrLwUbNolxZj4DIrMlEspEBPjcpaIwd1xFFE=";

    meta = with lib; {
      homepage = "https://surrealdb.com";
      description = "A native multi-model database with flexible data models for documents, graphs, and key-values";
      license = [ licenses.mit licenses.asl20 ];
      platforms = platforms.linux;
      maintainers = [ ];
    };
  };
  prebuilt = { version, sha256 }:
    let
      SURREALDB_ROOT = "https://download.surrealdb.com";

      ext = "tgz";

      oss = "linux"; # TODO fix
      cpu = "amd64";
      arc = "${oss}-${cpu}";
      url = "${SURREALDB_ROOT}/${version}/surreal-v${version}.${arc}.${ext}";
      tar =
        builtins.fetchTarball {
          inherit url sha256;

        };
    in
    stdenv.mkDerivation {
      pname = "surrealdb";
      inherit version;
      src = tar;
      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/bin
        ln -sf ${tar} $out/bin/surrealdb
      '';

      meta = with lib; {
        homepage = "https://surrealdb.com";
        description = "";
        license = [ licenses.bsl11 licenses.asl20 ];
        platforms = platforms.linux;
        maintainers = [ ];
      };
    };
in
(common {
  version = "v1.0.0-beta.6";
  sha256 = "sha256-C2+Oo2IbI5g27kfQZcBm44Uhin/KMFfq/dPINqopy+k=";

}) //
{
  prebuilt = prebuilt {
    version = "v1.0.0-beta.6";
    sha256 = "sha256:08610fi0i420rrqwrzfnvirrf97wfdlcbb0dpzfb34mnwn4pbkd7";
  };
}
