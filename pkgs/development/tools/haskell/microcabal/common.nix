{
  version,
  rev,
  hash,
}:

{
  lib,
  microhs,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation {
  pname = "microcabal-stage1";
  inherit version;

  src = fetchFromGitHub {
    owner = "augustss";
    repo = "MicroCabal";
    inherit rev hash;
  };

  patches = [
    (fetchpatch {
      name = "magichash-parse.patch";
      url = "https://github.com/augustss/MicroCabal/commit/c4e9fa6b4a62300f5230f6ec4ac47746b16775b6.patch";
      hash = "sha256-MpLNgwOryBJTAasYkglmuY6mMLPZ9gRRINp1kQdj2uo=";
    })
    patches/nixpkgs-compat.patch
  ];

  makeFlags = [
    "MHS=${microhs}/bin/mhs"
    "MHSDIR=${microhs}/lib/mhs"
  ];

  installPhase = ''
    runHook preInstall
    install -m755 -d $out/bin
    install -m755 bin/mcabal $out/bin/mcabal
    runHook postInstall
  '';

  meta = {
    description = "A partial Cabal replacement";
    longDescription = ''
      A portable subset of the Cabal functionality.
    '';
    homepage = "https://github.com/augustss/MicroCabal";
    license = lib.licensesSpdx."Apache-2.0";
    mainProgram = "mcabal";
    maintainers = with lib.maintainers; [ AlexandreTunstall ];
    platforms = lib.platforms.all;
  };
}
