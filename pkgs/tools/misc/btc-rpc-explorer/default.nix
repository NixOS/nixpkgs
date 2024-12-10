{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  python3,
  vips,
}:

buildNpmPackage rec {
  pname = "btc-rpc-explorer";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "janoside";
    repo = "btc-rpc-explorer";
    rev = "v${version}";
    hash = "sha256-ZGg3jwSl1XyzS9hMa2YqwExhHSNgrsUmSscZtfF2h54=";
  };

  npmDepsHash = "sha256-9pVjydGaEaHytZqwXv0/kaJAVqlE7zzuTvubBFTkuBg=";

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

  makeCacheWritable = true;

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    vips
  ];

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/janoside/btc-rpc-explorer/blob/${src.rev}/CHANGELOG.md";
    description = "Database-free, self-hosted Bitcoin explorer, via RPC to Bitcoin Core";
    homepage = "https://github.com/janoside/btc-rpc-explorer";
    license = lib.licenses.mit;
    mainProgram = "btc-rpc-explorer";
    maintainers = with lib.maintainers; [ d-xo ];
  };
}
