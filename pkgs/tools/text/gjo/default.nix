{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gjo";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "gjo";
    rev = version;
    sha256 = "07halr0jzds4rya6hlvp45bjf7vg4yf49w5q60mch05hk8qkjjdw";
  };

  doCheck = true;

  vendorSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  meta = with stdenv.lib; {
    description = "Small utility to create JSON objects";
    homepage = "https://github.com/skanehira/gjo";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
