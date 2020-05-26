{ buildGoModule
, fetchFromGitHub
, icu
}:

buildGoModule rec {
  pname = "usql";
  version = "0.7.8";
  src = fetchFromGitHub {
    owner = "xo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hgglafqRDvWoMFynoiXdedfhNYrdUMh7tTxkJS2fr3s=";
  };
  vendorHash = "sha256-UMucjhd9J4mciHHujxPHr1dk/un6dGHG3ejrGxNYA0w=";
  buildInputs = [ icu ];
  buildPhase = ''
    outdir=$out/bin
    mkdir -p $outdir
    pkg="github.com/xo/usql"
    go build \
      -tags "most sqlite_app_armor sqlite_icu sqlite_fts5 sqlite_introspect 
      sqlite_json1 sqlite_stat4 sqlite_userauth sqlite_vtable no_adodb no_ql" \
      -ldflags "-s -w -X $pkg/text.CommandVersion=${version}" \
      -o $outdir/usql

  '';
}
