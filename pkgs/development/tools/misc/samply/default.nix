{ lib
, rustPlatform
, fetchCrate
, jq
, moreutils
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "samply";
  version = "0.11.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-V0uAS7Oo7wv0yU5CgqqYhltwM5PXJ3GP/TLVZV2GkkI=";
  };

  cargoHash = "sha256-jsuICNVY3noZi/+mgVj9uUu53z+5bW9Vi5CBKcHOqSI=";

  # the dependencies linux-perf-data and linux-perf-event-reader contains both README.md and Readme.md,
  # which causes a hash mismatch on systems with a case-insensitive filesystem
  # this removes the readme files and updates cargo's checksum file accordingly
  depsExtraArgs = {
    nativeBuildInputs = [
      jq
      moreutils
    ];

    postBuild = ''
      for crate in linux-perf-data linux-perf-event-reader; do
        pushd $name/$crate

        rm -f README.md Readme.md
        jq 'del(.files."README.md") | del(.files."Readme.md")' \
          .cargo-checksum.json -c \
          | sponge .cargo-checksum.json

        popd
      done
    '';
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "A command line profiler for macOS and Linux";
    homepage = "https://github.com/mstange/samply";
    changelog = "https://github.com/mstange/samply/releases/tag/samply-v${version}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
