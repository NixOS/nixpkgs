{ stdenv, fetchFromGitHub, crystal, pcre, libyaml, which }:

stdenv.mkDerivation rec {
  pname = "shards";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner  = "crystal-lang";
    repo   = "shards";
    rev    = "v${version}";
    sha256 = "19q0xww4v0h5ln9gz8d8zv0c9ig761ik7gw8y31yxynzgzihwpf4";
  };

  buildInputs = [ crystal libyaml pcre which ];

  buildFlags = [ "CRFLAGS=--release" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/shards $out/bin/shards

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Dependency manager for the Crystal language";
    license     = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (crystal.meta) homepage platforms;
  };
}
