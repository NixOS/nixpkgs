{ stdenv, buildGoModule, fetchFromGitHub, pkg-config, btrfs-progs, gpgme, lvm2 }:

buildGoModule rec {
  pname = "dive";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bqmrva7rx6al50fmy4gvf853csascc5mj6ihgg7ydsy0d99j5qn";
  };

  modSha256 = "0hb7bq8v6xr8xqni1iv3zkqdnknfy539sm0vxqal1mhvs5yg06m0";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ btrfs-progs gpgme lvm2 ];

  meta = with stdenv.lib; {
    description = "A tool for exploring each layer in a docker image";
    homepage = https://github.com/wagoodman/dive;
    license = licenses.mit;
    maintainers = with maintainers; [ marsam spacekookie ];
  };
}
