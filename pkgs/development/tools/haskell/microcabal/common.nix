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
      # https://github.com/augustss/MicroCabal/pull/23
      name = "remove-mtl-mhs-override.patch";
      url = "https://github.com/AlexandreTunstall/MicroCabal/commit/ad30461aaf3dd295f4f5cf5db12635e42557cbfa.patch";
      hash = "sha256-Gmlt76C19ZtCHpKyNim0ggtjXnVuq5F0ywvX8BW15uM=";
    })
    (fetchpatch {
      # https://github.com/augustss/MicroCabal/pull/34
      name = "package-install-path.patch";
      url = "https://github.com/augustss/MicroCabal/commit/dc358bbab312e1788564fbb36f835347c21792c0.patch";
      hash = "sha256-aUQwuyp+ihXZ9PeSCqGUylcvzA6/ktZyeyBXiEoVY54=";
    })
    (fetchpatch {
      # https://github.com/augustss/MicroCabal/pull/34
      name = "package-search-path.patch";
      url = "https://github.com/augustss/MicroCabal/commit/3898e5f0596a7391818a0a2cfa994317cda62479.patch";
      hash = "sha256-76yEUpzH5xZZt3U+BCSqyWsImfpOEowupd5YCaYVTO0=";
    })
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
