{ buildGoModule
, fetchFromGitHub
}:
let
  mkBasePackage =
    { pname
    , src
    , version
    , vendorHash
    , cmd
    , extraLdflags
    , ...
    }@args: buildGoModule (rec {
      inherit pname src vendorHash version;

      sourceRoot = "${src.name}/provider";

      subPackages = [ "cmd/${cmd}" ];

      doCheck = false;

      ldflags = [
        "-s"
        "-w"
      ] ++ extraLdflags;
    } // args);
in
{ owner
, repo
, rev
, version
, hash
, vendorHash
, cmdGen
, cmdRes
, extraLdflags
, meta
, fetchSubmodules ? false
, ...
}@args:
let
  src = fetchFromGitHub {
    name = "source-${repo}-${rev}";
    inherit owner repo rev hash fetchSubmodules;
  };

  pulumi-gen = mkBasePackage rec {
    inherit src version vendorHash extraLdflags;

    cmd = cmdGen;
    pname = cmdGen;
  };
in
mkBasePackage ({
  inherit meta src version vendorHash extraLdflags;

  pname = repo;

  nativeBuildInputs = [
    pulumi-gen
  ];

  cmd = cmdRes;

  postConfigure = ''
    pushd ..

    chmod +w sdk/
    ${cmdGen} schema

    popd

    VERSION=v${version} go generate cmd/${cmdRes}/main.go
  '';
} // args)
