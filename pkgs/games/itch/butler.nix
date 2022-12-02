{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, Cocoa
, fetchpatch
}:

buildGoModule rec {
  pname = "butler";
  version = "15.21.0";

  src = fetchFromGitHub {
    owner = "itchio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vciSmXR3wI3KcnC+Uz36AgI/WUfztA05MJv1InuOjJM=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    Cocoa
  ];

  patches = [
    # update x/sys dependency for darwin build https://github.com/itchio/butler/pull/245
    (fetchpatch {
      url = "https://github.com/itchio/butler/pull/245/commits/ef651d373e3061fda9692dd44ae0f7ce215e9655.patch";
      hash = "sha256-rZZn/OGiv3mRyy89uORyJ99zWN21kZCCQAlFvSKxlPU=";
    })
  ];

  proxyVendor = true;

  vendorSha256 = "sha256-CtBwc5mcgLvl2Bvg5gI+ULJMQEEibx1aN3IpmRNUtwE=";

  doCheck = false;

  meta = with lib; {
    description = "Command-line itch.io helper";
    homepage = "https://github.com/itchio/butler";
    license = licenses.mit;
    maintainers = with maintainers; [ martfont ];
  };
}
