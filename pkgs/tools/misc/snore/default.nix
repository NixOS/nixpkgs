{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  version = "0.2";
  pname = "snore";

  src = fetchFromGitHub {
    owner = "clamiax";
    repo = pname;
    rev = version;
    sha256 = "sha256-EOwbRqtQEuGZ+aeCBNVfLUq4m/bFWJTvMDM6a+y74qc=";
  };

  patches = [
    # Fix POSIX_C_SOURCE macro. Remove with the next release.
    (fetchpatch {
      url = "https://github.com/clamiax/snore/commit/284e5aa56e775803d24879954136401a106aa063.patch";
      sha256 = "sha256-len8E8h9CXC25WB2lmnLLJ0PR903tgllDh9K2RqzQk0=";
    })
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "sleep with feedback";
    homepage = "https://github.com/clamiax/snore";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
  };
}
