{
  acl,
  fetchFromGitHub,
  lib,
  rustPlatform,
  fetchpatch2,
}:

rustPlatform.buildRustPackage rec {
  pname = "laurel";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "threathunters-io";
    repo = "laurel";
    tag = "v${version}";
    hash = "sha256-1UjIye+btsNtf9Klti/3frgO7M+D05WkC1iP+TPQkZk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-N5mgd2c/eD0QEUQ4Oe7JI/2yI0B1pawYfc4ZKZAu4Sk=";

  patches = [
    # https://github.com/threathunters-io/laurel/commit/d2fc51c83e78aecd5c4ce922582df649c2600e1e
    # Unbreaks the userdb::test::userdb test. Will be part of the next release (likely v0.6.6).
    (fetchpatch2 {
      url = "https://github.com/threathunters-io/laurel/commit/d2fc51c83e78aecd5c4ce922582df649c2600e1e.patch?full_index=1";
      hash = "sha256-OId5ZCF71ikoCSggyy3u4USR71onFJpirp53k4M17Vo=";
    })
  ];

  postPatch = ''
    # Upstream started to redirect aarch64-unknown-linux-gnu to aarch64-linux-gnu-gcc
    # for their CI which breaks compiling on aarch64 in nixpkgs:
    #  error: linker `aarch64-linux-gnu-gcc` not found
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [ rustPlatform.bindgenHook ];
  buildInputs = [ acl ];

  meta = with lib; {
    description = "Transform Linux Audit logs for SIEM usage";
    homepage = "https://github.com/threathunters-io/laurel";
    changelog = "https://github.com/threathunters-io/laurel/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilylange ];
    platforms = platforms.linux;
  };
}
