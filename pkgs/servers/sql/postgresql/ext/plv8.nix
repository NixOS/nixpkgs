{ stdenv, fetchFromGitHub, v8, perl, postgresql }:

stdenv.mkDerivation rec {
  pname = "plv8";
  version = "2.3.15";

  nativeBuildInputs = [ perl ];
  buildInputs = [ v8 postgresql ];

  src = fetchFromGitHub {
    owner = "plv8";
    repo = "plv8";
    rev = "v${version}";
    sha256 = "1cv94n49gq2b377gqyq7pjjzw98czv4mwl3sx97y18c20zwp6rk3";
  };

  makefile = "Makefile.shared";

  buildFlags = [ "all" ];

  preConfigure = ''
    patchShebangs ./generate_upgrade.sh
  '';

  installPhase = ''
    install -D plv8*.so                                        -t $out/lib
    install -D {plls,plcoffee,plv8}{--${version}.sql,.control} -t $out/share/postgresql/extension
  '';

  meta = with stdenv.lib; {
    description = "V8 Engine Javascript Procedural Language add-on for PostgreSQL";
    homepage = "https://plv8.github.io/";
    maintainers = with maintainers; [ volth marsam ];
    platforms = [ "x86_64-linux" ];
    license = licenses.postgresql;
  };
}
