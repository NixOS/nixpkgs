{ stdenv, fetchgit, callPackage, python, utillinux }:

with stdenv.lib;

let 
  nodePackages = callPackage (import ../../../top-level/node-packages.nix) {
    neededNatives = [python] ++ optional (stdenv.isLinux) utillinux;
    self = nodePackages;
    generated = ./package.nix;
  };

in nodePackages.buildNodePackage rec {
  name = "airfield-${version}";
  version = "5ae816562a";

  src = [(fetchgit {
    url = https://github.com/emblica/airfield.git;
    rev = version;
    sha256 = "0rv05pq0xdm0d977dc3hg6dam78acymzrdvkxs8ga8xj4vfs5npk";
  })];

  deps = (filter (v: nixType v == "derivation") (attrValues nodePackages));

  preInstall = ''
    substituteInPlace node_modules/Airfield/airfield.js \
        --replace "'./settings'" "process.env.NODE_CONFIG"
  '';

  passthru.names = ["Airfield"];

  meta = {
    description = "A web-interface for hipache-proxy";
    license = licenses.mit;
    homepage = https://github.com/emblica/airfield;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
    broken = true;
  };
}
