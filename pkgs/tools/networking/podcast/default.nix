{ stdenv, fetchpatch, fetchFromGitHub, rustPlatform, pkgconfig, openssl, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "podcast";
  version = "0.17.5";

  src = fetchFromGitHub {
    owner = "njaremko";
    repo = pname;
    rev = version;
    sha256 = "1g1a6yw0zxyc6vjlbycvwnm501b5hz1xkz2lnadscvmlhnld0cc2";
  };

  cargoSha256 = "0h97j6g988xjm0b2yv2cpzdcwzs1srznpl7h7ibqps8pbblfi5rs";

  cargoPatches = [
    (fetchpatch {
      url =
        "https://github.com/njaremko/podcast/commit/ecf96f79c765e36ca86f24dbdcc4a217914479eb.diff";
      sha256 = "02pk8r30i1p66lwhnb3a112b612pri8ydd6fpccx71gs4rrl8pkp";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Security ]);

  meta = with stdenv.lib; {
    description = "Command line podcast manager and player";
    homepage = "https://github.com/njaremko/podcast";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ djanatyn ];
  };
}
