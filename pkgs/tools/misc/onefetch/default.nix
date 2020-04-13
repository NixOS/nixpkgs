{ fetchFromGitHub, rustPlatform, stdenv, fetchpatch
, CoreFoundation, libiconv, libresolv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sgpai3gx3w7w3ilmbnmzgdxdim6klkfiqaqxmffpyap6qgksfqs";
  };

  cargoSha256 = "18z887mklynxpjci6va4i5zhg90j824avykym24vbz9w97nqpdd5";

  buildInputs = with stdenv;
    lib.optionals isDarwin [ CoreFoundation libiconv libresolv Security ];

  cargoPatches = [
    # fix wrong version in Cargo.lock
    (fetchpatch {
      url = "https://github.com/o2sh/onefetch/commit/b69fe660d72b65d7efac99ac5db3b03a82d8667f.patch";
      sha256 = "14przkdyd4yd11xpdgyscs70w9gpnh02j3xdzxf6h895w3mn84lx";
    })
  ];

  meta = with stdenv.lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
