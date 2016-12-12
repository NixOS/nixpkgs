{ stdenv, fetchFromGitHub, fetchpatch, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "simp_le-2016-04-17";

  src = fetchFromGitHub {
    owner = "kuba";
    repo = "simp_le";
    rev = "3a103b76f933f9aef782a47401dd2eff5057a6f7";
    sha256 = "0x8gqazn09m30bn1l7xnf8snhbb7yz7sb09imciqmm4jqdvn797z";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/kuba/simp_le/commit/4bc788fdd611c4118c3f86b5f546779723aca5a7.patch";
      sha256 = "0036p11qn3plydv5s5z6i28r6ihy1ipjl0y8la0izpkiq273byfc";
    })
    (fetchpatch {
      url = "https://github.com/kuba/simp_le/commit/9ec7efe593cadb46348dc6924c1e6a31f0f9e636.patch";
      sha256 = "0n3m94n14y9c42185ly47d061g6awc8vb8xs9abffaigxv59k06j";
    })
  ];

  propagatedBuildInputs = with pythonPackages; [ acme ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner nckx ];
    platforms = platforms.all;
  };
}
