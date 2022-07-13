{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, libcap
}:

let

  # ncdns source
  ncdns = fetchFromGitHub {
    owner = "namecoin";
    repo = "ncdns";
    rev = "2a486311b0fe1a921af34aa3b31e6e4e0569accc";
    sha256 = "01arwlycp1iia4bd3dgyn8dam1av2a7d9hv7f085n14l2i2aza7v";
  };

  # script to patch the crypto/x509 package
  x509 = fetchFromGitHub {
    owner = "namecoin";
    repo = "x509-compressed";
    rev = "fb9f2b7bc9fcba954d70f63857cc0c3841b1cf47";
    sha256 = "1arkbpbzvhcmz5fhjqg34x2jbjnwmlisapk22rjki17qpamh7zks";
    # ncdns must be put in a subdirectory for this to work.
    postFetch = ''
      cp -r --no-preserve=mode "${ncdns}" "$out/ncdns"
    '';
  };

in

buildGoModule {
  pname = "ncdns";
  version = "unstable-2020-07-18";

  src = x509;

  vendorSha256 = "02bqf6vkj5msk35sr5sklnqqd16n7gns7knzqslw077xrxiz7bsg";

  # Override the go-modules fetcher derivation to apply
  # upstream's patch of the crypto/x509 library.
  modBuildPhase = ''
    go mod init github.com/namecoin/x509-compressed
    go generate ./...
    go mod tidy

    cd ncdns
    go mod init github.com/namecoin/ncdns
    go mod edit \
      -replace github.com/coreos/go-systemd=github.com/coreos/go-systemd/v22@latest \
      -replace github.com/namecoin/x509-compressed=$NIX_BUILD_TOP/source
    go mod tidy
  '';

  # Copy over the lockfiles as well, because the source
  # doesn't contain it. The fixed-output derivation is
  # probably not reproducible anyway.
  modInstallPhase = ''
    mv -t vendor go.mod go.sum
    cp -r --reflink=auto vendor "$out"
  '';

  buildInputs = [ libcap ];

  # The fetcher derivation must run with a different
  # $sourceRoot, but buildGoModule doesn't allow that,
  # so we use this ugly hack.
  unpackPhase = ''
    runHook preUnpack

    unpackFile "$src"
    sourceRoot=$PWD/source/ncdns
    chmod -R u+w -- "$sourceRoot"
    cd $sourceRoot

    runHook postUpack
  '';

  # Same as above: can't use `patches` because that would
  # be also applied to the fetcher derivation, thus failing.
  patchPhase = ''
    runHook prePatch
    patch -p1 < ${./fix-tpl-path.patch}
    runHook postPatch
  '';

  preBuild = ''
    chmod -R u+w vendor
    mv -t . vendor/go.{mod,sum}
  '';

  preCheck = ''
    # needed to run the ncdns test suite
    ln -s $PWD/vendor ../../go/src
  '';

  postInstall = ''
    mkdir -p "$out/share"
    cp -r _doc "$out/share/doc"
    cp -r _tpl "$out/share/tpl"
  '';

  passthru.tests.ncdns = nixosTests.ncdns;

  meta = with lib; {
    description = "Namecoin to DNS bridge daemon";
    homepage = "https://github.com/namecoin/ncdns";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rnhmjoj ];
    # module github.com/btcsuite/btcd@latest found (v0.23.1), but does not contain package github.com/btcsuite/btcd/btcec
    broken = true;
  };
}
