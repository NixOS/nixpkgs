{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, externalPlugins ? []
, vendorHash ? "sha256-tp22jj6DNnYFQhtAFW2uLo10ty//dyNqIDH2egDgbOw="
}:

let
  attrsToPlugins = attrs:
    builtins.map ({name, repo, version}: "${name}:${repo}") attrs;
  attrsToSources = attrs:
    builtins.map ({name, repo, version}: "${repo}@${version}") attrs;
in buildGoModule rec {
  pname = "coredns";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "sha256-XZoRN907PXNKV2iMn51H/lt8yPxhPupNfJ49Pymdm9Y=";
  };

  inherit vendorHash;

  nativeBuildInputs = [ installShellFiles ];

  outputs = [ "out" "man" ];

  # Override the go-modules fetcher derivation to fetch plugins
  modBuildPhase = ''
    for plugin in ${builtins.toString (attrsToPlugins externalPlugins)}; do echo $plugin >> plugin.cfg; done
    for src in ${builtins.toString (attrsToSources externalPlugins)}; do go get $src; done
    GOOS= GOARCH= go generate
    go mod vendor
  '';

  modInstallPhase = ''
    mv -t vendor go.mod go.sum plugin.cfg
    cp -r --reflink=auto vendor "$out"
  '';

  preBuild = ''
    chmod -R u+w vendor
    mv -t . vendor/go.{mod,sum} vendor/plugin.cfg

    GOOS= GOARCH= go generate
  '';

  postPatch = ''
    substituteInPlace test/file_cname_proxy_test.go \
      --replace "TestZoneExternalCNAMELookupWithProxy" \
                "SkipZoneExternalCNAMELookupWithProxy"

    substituteInPlace test/readme_test.go \
      --replace "TestReadme" "SkipReadme"

    # this test fails if any external plugins were imported.
    # it's a lint rather than a test of functionality, so it's safe to disable.
    substituteInPlace test/presubmit_test.go \
      --replace "TestImportOrdering" "SkipImportOrdering"
  '' + lib.optionalString stdenv.isDarwin ''
    # loopback interface is lo0 on macos
    sed -E -i 's/\blo\b/lo0/' plugin/bind/setup_test.go
  '';

  postInstall = ''
    installManPage man/*
  '';

  meta = with lib; {
    homepage = "https://coredns.io";
    description = "DNS server that runs middleware";
    mainProgram = "coredns";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
