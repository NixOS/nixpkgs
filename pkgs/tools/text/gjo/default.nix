{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gjo";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "gjo";
    rev = version;
    sha256 = "1m5nkv42ri150fgj590nrl24wp90p7ygg9xdh9zblibmnqrvbz4z";
  };

  doCheck = true;

  modSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  meta = with stdenv.lib; {
    description = "Small utility to create JSON objects";
    homepage = "https://github.com/skanehira/gjo";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}

