{ lib
, fetchFromGitHub
, fetchurl
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "pw-volume";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "smasher164";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-u7Ct9Kfwld/h3b6hUZdfHNuDGE4NA3MwrmgUj4g64lw=";
  };

  cargoPatches = [
    (fetchurl {
      # update Cargo.lock
      url = "https://github.com/smasher164/pw-volume/commit/be104eaaeb84def26b392cc44bb1e7b880bef0fc.patch";
      sha256 = "sha256-gssRcKpqxSAvW+2kJzIAR/soIQ3xg6LDZ7OeXds4ulY=";
    })
  ];

  cargoSha256 = "sha256-Vzd5ZbbzJh2QqiOrBOszsNqLwxM+mm2lbGd5JtKZzEM=";

  meta = with lib; {
    description = "Basic interface to PipeWire volume controls";
    homepage = "https://github.com/smasher164/pw-volume";
    license = licenses.mit;
    maintainers = with maintainers; [ astro ];
    platforms = platforms.linux;
  };
}
