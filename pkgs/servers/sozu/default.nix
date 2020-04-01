{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
    pname = "sozu";
    version = "0.11.46";

    src = fetchFromGitHub {
        owner = "sozu-proxy";
        repo = pname;
        rev = version;
        sha256 = "0anng5qvdx9plxs9qqr5wmjjz0gx5113jq28xwbxaaklvd4ni7cm";
    };

    cargoSha256 = "19c2s9h4jk9pff72wdqw384mvrf40d8x4sx7qysnpb4hayq2ijh3";

    meta = with stdenv.lib; {
        description = "Open Source HTTP Reverse Proxy built in Rust for Immutable Infrastructures";
        homepage = "https://sozu.io";
        license = licenses.agpl3;
        maintainers = with maintainers; [ filalex77 ];
    };
}