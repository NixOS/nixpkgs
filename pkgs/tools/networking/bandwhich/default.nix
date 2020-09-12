{ stdenv, fetchFromGitHub, rustPlatform, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "bandwhich";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = pname;
    rev = version;
    sha256 = "0qzmkhrg7pqgblmva7xcww6zc4rryba6kkfkhj05mvd31z3c1rz8";
  };

  cargoSha256 = "0iakw42nip0vxq50jjk73r0xl7xp426szb091ap4isad3zxq6saj";
  cargoPatches = [
    # Fixes rDNS support for systems using `systemd-networkd` from v246.
    # See https://github.com/imsnif/bandwhich/pull/184 for context
    (fetchpatch {
      url = "https://github.com/imsnif/bandwhich/commit/19e485a1ce9f749c121d235147e3117cc847379e.patch";
      sha256 = "03hg73gwlfq0l36k3aq7cfak3js7j05ssfpdbfiiwqq7lynm83jr";
    })
    (fetchpatch {
      url = "https://github.com/imsnif/bandwhich/commit/35f03b716832fba9a735628d1c728d3e305f75c8.patch";
      sha256 = "1bv837wc1dgg26s640f3lfya28ypnjs0675dykzxxxv5y9ns58l3";
    })
  ];

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A CLI utility for displaying current network utilization";
    longDescription = ''
      bandwhich sniffs a given network interface and records IP packet size, cross
      referencing it with the /proc filesystem on linux or lsof on MacOS. It is
      responsive to the terminal window size, displaying less info if there is
      no room for it. It will also attempt to resolve ips to their host name in
      the background using reverse DNS on a best effort basis.
    '';
    homepage = "https://github.com/imsnif/bandwhich";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ma27 ];
    platforms = platforms.unix;
  };
}
