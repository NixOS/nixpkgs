{ lib
, buildGoModule
, fetchFromGitHub
, hyperscan
, pkg-config
}:

buildGoModule rec {
  pname = "secretscanner";
  version = "20210214-${lib.strings.substring 0 7 rev}";
  rev = "42a38f9351352bf6240016b5b93d971be35cad46";

  src = fetchFromGitHub {
    owner = "deepfence";
    repo = "SecretScanner";
    inherit rev;
    sha256 = "0yga71f7bx5a3hj5agr88pd7j8jnxbwqm241fhrvv8ic4sx0mawg";
  };

  vendorSha256 = "0b7qa83iqnigihgwlqsxi28n7d9h0dk3wx1bqvhn4k01483cipsd";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ hyperscan ];

  postInstall = ''
    mv $out/bin/SecretScanner $out/bin/$pname
  '';

  meta = with lib; {
    description = "Tool to find secrets and passwords in container images and file systems";
    homepage = "https://github.com/deepfence/SecretScanner";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

